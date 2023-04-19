module RedmineWebhook
    class UserWrapper
        include GravatarHelper::PublicMethods
        include ERB::Util

        def initialize(author)
            @user = author
        end

        def to_map
            return nil unless @user
            {
                :id => @user.id,
                :login => @user.login,
                :mail => @user.mail,
                :firstname => @user.firstname,
                :lastname => @user.lastname,
                :identity_url => @user.try(:identity_url),
                :icon_url => icon_url
            }
        end

        def icon_url
            if @user.mail.blank?
                icon_url = nil
            else
                icon_url = gravatar_url(@user.mail)
            end
        end
    end
end
