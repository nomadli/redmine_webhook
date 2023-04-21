class RedmineWebhookHelper
    include Redmine::I18n
  
    def self.create_button (context)
        if Setting.plugin_redmine_webhook[:api_url].empty?
            l(:notice_fail_setting_err)
            return ""
        end
        
        cissue = context[:issue]
        if !cissue[:id]
            return ""
        end

        status_id = cissue[:status_id]
        issue_status = IssueStatus.find(status_id)
        if issue_status[:is_closed] == true
            return ""
        end

        webhooks = Array.new
        if Setting.plugin_redmine_webhook[:per_project]
            project = cissue.project
            webhooks = Webhook.where(:project_id => project.project.id)
            webhooks = Webhook.where(:project_id => 0) unless webhooks && webhooks.length > 0
            return unless webhooks
        elsif Setting.plugin_redmine_webhook[:api_url]
            webhook = Webhook.new(:project_id => 0)
            webhook.url = Setting.plugin_redmine_webhook[:api_url]
            webhooks << webhook
        end

        if webhooks.length() <= 0
            return ""
        end

        api_url = webhooks[0].url
        token = Setting.plugin_redmine_webhook[:token]
        controller = context[:controller]
        data = {
            :action => 3,
            :issue => RedmineWebhook::IssueWrapper.new(cissue).to_map,
            :url => controller.nil? ? "not yet implemented" : controller.issue_url(cissue),
            :user => RedmineWebhook::UserWrapper.new(User.current).to_map
        }.to_json
        data = data.gsub(/\\/, '\\'=>'\\\\')

        html = '<script>
        var button = $("<a class=\"icon icon-webhook\" onclick=\"click_post()\">'+ l(:button_label) +'</a>");
        button.insertBefore($("#content>.contextual:first .drdn"));
        button = $("<a class=\"icon icon-webhook\" onclick=\"click_post()\">'+ l(:button_label) +'</a>");
        button.insertBefore($("#content>.contextual:last .drdn"));

        function click_post() {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "' + api_url + '", true);
            xhr.withCredentials = true;
            xhr.setRequestHeader("Content-type","application/json; charset=utf-8");
            '
            if token
                html = html + 'xhr.setRequestHeader("Token", "' + token + '");'
            end
            html = html + 'xhr.send(\'' + data + '\');
        }
        </script>'

        return html
    end
end
