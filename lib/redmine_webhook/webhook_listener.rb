module RedmineWebhook
    class WebhookListener < Redmine::Hook::ViewListener
        def view_layouts_base_html_head(context)
            stylesheet_link_tag 'style', :plugin => :redmine_webhook
        end

        def view_issues_form_details_bottom(context={})
            if Setting.plugin_redmine_webhook[:show_button]
                return RedmineWebhookHelper.create_button context
            end
            return ""
        end

        def controller_issues_new_after_save(context = {})
            return if skip_webhooks(context)
            issue = context[:issue]
            controller = context[:controller]
            project = issue.project

            webhooks = Array.new
            if Setting.plugin_redmine_webhook[:per_project]
                webhooks = Webhook.where(:project_id => project.project.id)
                webhooks = Webhook.where(:project_id => 0) unless webhooks && webhooks.length > 0
                return unless webhooks
            elsif Setting.plugin_redmine_webhook[:api_url]
                webhook = Webhook.new(:project_id => 0)
                webhook.url = Setting.plugin_redmine_webhook[:api_url]
                webhooks << webhook
            end

            post(webhooks, issue_to_json(issue, controller))
        end

        def controller_issues_edit_after_save(context = {})
            return if skip_webhooks(context)
            journal = context[:journal]
            controller = context[:controller]
            issue = context[:issue]
            project = issue.project
            
            webhooks = Array.new
            if Setting.plugin_redmine_webhook[:per_project]
                webhooks = Webhook.where(:project_id => project.project.id)
                webhooks = Webhook.where(:project_id => 0) unless webhooks && webhooks.length > 0
                return unless webhooks
            elsif Setting.plugin_redmine_webhook[:api_url]
                webhook = Webhook.new(:project_id => 0)
                webhook.url = Setting.plugin_redmine_webhook[:api_url]
                webhooks << webhook
            end

            post(webhooks, journal_to_json(issue, journal, controller))
        end

        def controller_issues_bulk_edit_after_save(context = {})
            return if skip_webhooks(context)
            journal = context[:journal]
            controller = context[:controller]
            issue = context[:issue]
            project = issue.project
            
            webhooks = Array.new
            if Setting.plugin_redmine_webhook[:per_project]
                webhooks = Webhook.where(:project_id => project.project.id)
                webhooks = Webhook.where(:project_id => 0) unless webhooks && webhooks.length > 0
                return unless webhooks
            elsif Setting.plugin_redmine_webhook[:api_url]
                webhook = Webhook.new(:project_id => 0)
                webhook.url = Setting.plugin_redmine_webhook[:api_url]
                webhooks << webhook
            end

            post(webhooks, journal_to_json(issue, journal, controller))
        end

        def model_changeset_scan_commit_for_issue_ids_pre_issue_update(context = {})
            issue = context[:issue]
            journal = issue.current_journal
            
            webhooks = Array.new
            if Setting.plugin_redmine_webhook[:per_project]
                webhooks = Webhook.where(:project_id => project.project.id)
                webhooks = Webhook.where(:project_id => 0) unless webhooks && webhooks.length > 0
                return unless webhooks
            elsif Setting.plugin_redmine_webhook[:api_url]
                webhook = Webhook.new(:project_id => 0)
                webhook.url = Setting.plugin_redmine_webhook[:api_url]
                webhooks << webhook
            end
            
            post(webhooks, journal_to_json(issue, journal, nil))
        end

        private
        def skip_webhooks(context)
            return true unless context[:request]
            return true if context[:request].headers['X-Skip-Webhooks']
                false
        end

        def issue_to_json(issue, controller)
            {
                :action => 1,
                :issue => RedmineWebhook::IssueWrapper.new(issue).to_map,
                :url => controller.issue_url(issue)
            }.to_json
        end

        def journal_to_json(issue, journal, controller)
            {
                :action => 2,
                :issue => RedmineWebhook::IssueWrapper.new(issue).to_map,
                :journal => RedmineWebhook::JournalWrapper.new(journal).to_map,
                :url => controller.nil? ? 'not yet implemented' : controller.issue_url(issue)
            }.to_json
        end

        def post(webhooks, request_body)
            Thread.start do
                webhooks.each do |webhook|
                begin
                    Faraday.post do |req|
                        req.url webhook.url
                        req.headers['Content-Type'] = 'application/json'
                        req.body = request_body
                    end
                    rescue => e
                        Rails.logger.error e
                    end
                end
            end
        end
    end
end
