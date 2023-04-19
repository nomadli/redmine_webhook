module RedmineWebhook
    class JournalWrapper
        def initialize(journal)
            @journal = journal
        end

        def to_map
            {
                :id => @journal.id,
                :notes => @journal.notes,
                :created_on => @journal.created_on,
                :private_notes => @journal.private_notes,
                :author => RedmineWebhook::UserWrapper.new(@journal.user).to_map,
                :details => @journal.details.map {|detail| RedmineWebhook::JournalDetailWrapper.new(detail).to_map }
            }
        end
    end
end
