module RedmineWebhook
    module ProjectsHelperPatch
        def project_settings_tabs
            tabs = super
            if !Setting.plugin_redmine_webhook[:per_project]
                tabs
            else
                webhook_tab = {
                    :name => 'webhook',
                    :controller => 'webhook_settings',
                    :action => :show,
                    :partial => 'webhook_settings/show',
                    :label => :webhook
                }
                tabs << webhook_tab if User.current.allowed_to?(:manage_hook, @project)
                tabs
            end
        end
    end
end

ProjectsController.send(:helper, RedmineWebhook::ProjectsHelperPatch)
