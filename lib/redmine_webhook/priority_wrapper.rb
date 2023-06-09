module RedmineWebhook
    class PriorityWrapper
        def initialize(priority)
            @priority = priority
        end

        def to_map
            {
                :id => @priority.id,
                :name => @priority.name
            }
        end
    end
end
