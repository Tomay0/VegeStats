require 'active_resource'

class Messages < ActiveResource::Base
    self.site = ENV["POSTGREST_URL"]
    self.headers['Authorization'] = "Bearer #{ENV["POSTGREST_TOKEN"]}"
    self.include_format_in_path = false

    def self.collection_name
        self.element_name
    end
end

class DiscordChannels < Messages
    self.element_name = "discordchannels"
end

class DiscordUsers < Messages
    self.element_name = "discordusers"
end

class DiscordGuilds < Messages
    self.element_name = "discordguilds"
end

class FullView < Messages
    self.element_name = "fullview"
end

class UserMessagesByGuild < Messages
    self.element_name = "usermessagesbyguild"
end

class UserMessagesByChannel < Messages
    self.element_name = "usermessagesbychannel"
end

class MessagesByChannel < Messages
    self.element_name = "messagesbychannel"
end