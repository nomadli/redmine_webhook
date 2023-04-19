module RedmineWebhook
    class TrackerWrapper
        def initialize(tracker)
            @tracker = tracker
        end

        def to_map
            {
                :id => @tracker.id,
                :name => @tracker.name
            }
        end
    end
end
