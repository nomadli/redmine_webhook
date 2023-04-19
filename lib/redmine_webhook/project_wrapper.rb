class RedmineWebhook::ProjectWrapper
    def initialize(project)
        @project = project
    end

    def to_map
        {
            :id => @project.id,
            :identifier => @project.identifier,
            :name => @project.name,
            :description => @project.description,
            :created_on => @project.created_on,
            :updated_on => @project.updated_on,
            :homepage => @project.homepage,
        }
    end
end
