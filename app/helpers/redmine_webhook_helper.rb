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

        host = Setting.plugin_redmine_webhook[:api_url]
        token = Setting.plugin_redmine_webhook[:token]
        controller = context[:controller]
        data = {
            :action => 3,
            :issue => RedmineWebhook::IssueWrapper.new(cissue).to_map,
            :url => controller.nil? ? 'not yet implemented' : controller.issue_url(cissue),
            :user => RedmineWebhook::UserWrapper.new(User.current).to_map
        }.to_json

        html = '<script>
        var button = $("<a class=\"icon icon-webhook\" onclick=\"click_post()\">'+ l(:button_label) +'</a>");
        $("#content .contextual:first").prepend(button);

        function click_post() {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "' + host + '", true);
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
