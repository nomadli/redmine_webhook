module RedmineWebhook
    class StatusWrapper
        def initialize(status)
            @status = status
        end

        def to_map
            {
                :id => @status.id,
                :name => @status.name
            }
        end
    end
end
