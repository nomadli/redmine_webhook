if Rails.try(:autoloaders).try(:zeitwerk_enabled?)
    Rails.autoloaders.main.push_dir File.dirname(__FILE__) + '/lib/redmine_webhook'
    RedmineWebhook::ProjectsHelperPatch
    RedmineWebhook::WebhookListener
else
    require "redmine_webhook"
end

Redmine::Plugin.register :redmine_webhook do
    name 'Redmine Webhook plugin'
    author 'nomadli'
    description 'A redmine webhook plugin post message on creating and updating'
    version '0.0.1'
    url 'https://github.com/nomadli/redmine_webhook'
    author_url 'http://nomadli.github.io'
    project_module :webhooks do
        permission :manage_hook, {:webhook_settings => [:index, :show, :update, :create, :destroy]}, :require => :member
    end
    settings :default => {
        :api_url => "",
        :token => "",
        :per_project => false,
        :show_button => true,
    }, :partial => 'settings/redmine_webhook_settings'
end
