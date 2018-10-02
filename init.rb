require 'redmine'

require_dependency 'redmine_slack/listener'

Redmine::Plugin.register :redmine_slack do
	name 'Redmine Slack yk'
	author 'Yasuo Kominami'
	url 'https://github.com/ykominami/redmine-slack'
	author_url 'http://www.northern-cross.info'
	description 'Slack chat integration'
	version '0.3'

	requires_redmine :version_or_higher => '0.8.0'

	settings \
		:default => {
			'callback_url' => 'http://slack.com/callback/',
			'channel' => nil,
			'icon' => 'https://raw.github.com/sciyoshi/redmine-slack/gh-pages/icon.png',
			'username' => 'redmine',
			'display_watchers' => 'no'
		},
		:partial => 'settings/slack_settings'
end

process_class = ActionDispatch::Callbacks.respond_to?( :to_prepare ) ? ActionDispatch::Callbacks : ActiveSupport::Reloader
process_class.to_prepare do
	require_dependency 'issue'
	unless Issue.included_modules.include? RedmineSlack::IssuePatch
		Issue.send(:include, RedmineSlack::IssuePatch)
	end
end
