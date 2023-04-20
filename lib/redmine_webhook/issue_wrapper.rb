module RedmineWebhook
    class IssueWrapper
        def initialize(issue)
            @issue = issue
        end

        def to_map
            {
                :id => @issue.id,
                :subject => @issue.subject,
                :description => @issue.description,
                :created_on => @issue.created_on,
                :updated_on => @issue.updated_on,
                :closed_on => @issue.closed_on,
                :root_id => @issue.root_id,
                :parent => {:id => @issue.parent_id},
                :done_ratio => @issue.done_ratio,
                :start_date => @issue.start_date,
                :due_date => @issue.due_date,
                :estimated_hours => @issue.estimated_hours,
                :total_estimated_hours => @issue.total_estimated_hours,
                :is_private => @issue.is_private,
                :lock_version => @issue.lock_version,
                :fixed_version => Version.find_by_id(@issue.fixed_version_id),
                :custom_fields => @issue.custom_field_values.collect { |value| RedmineWebhook::CustomFieldValueWrapper.new(value).to_map },
                :project => RedmineWebhook::ProjectWrapper.new(@issue.project).to_map,
                :status => RedmineWebhook::StatusWrapper.new(@issue.status).to_map,
                :tracker => RedmineWebhook::TrackerWrapper.new(@issue.tracker).to_map,
                :priority => RedmineWebhook::PriorityWrapper.new(@issue.priority).to_map,
                :author => RedmineWebhook::UserWrapper.new(@issue.author).to_map,
                :assigned_to => RedmineWebhook::UserWrapper.new(@issue.assigned_to).to_map,
                :watchers => @issue.watcher_users.collect{|u| RedmineWebhook::UserWrapper.new(u).to_map}
            }
        end
    end
end
