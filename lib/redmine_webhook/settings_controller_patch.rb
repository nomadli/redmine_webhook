require_dependency 'settings_controller'
module RedmineWebhook
    module SettingsControllerPatch
        def self.prepended(base)
            Rails.logger.info "nomadli=> self.prepended #{base}"
        end
        
        def authors
            Rails.logger.info "nomadli=> authors #{params}"
            @authors = "nomadli"
            render layout: false
        end
        
        def install_webhook
            Rails.logger.info "nomadli=> install_webhook #{params}"
            @plugin = Redmine::Plugin.find params[:id]
            return render_404
        end
        
        def plugin
            Rails.logger.info "nomadli=> plugin #{params}"
            if request.post?
                Rails.logger.info "nomadli=> plugin request.post"
            else
                Rails.logger.info "nomadli=> plugin 2"
            end
            return super
        end
    end
end
        
unless SettingsController.included_modules.include? RedmineWebhook::SettingsControllerPatch
    SettingsController.prepend RedmineWebhook::SettingsControllerPatch
end
