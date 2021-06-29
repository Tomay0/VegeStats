require "messages"

class StatsController < ApplicationController
    def get_server
        @id = params[:id]
        server = DiscordGuilds.where(guild_id: "eq.#{@id}").first
        
        if server.nil?
            return false
        end

        @server_name = server.guild_name
        return true
    end
    def index
        if !get_server()
            render "stats/404"
            return
        end
    end
    def user_messages
        if !get_server()
            render "stats/404"
            return
        end
        returned_data = UserMessagesByGuild.where(guild_id: "eq.#{@id}")
        @data = Hash[returned_data.collect {|item| [item.user_id, {:name => item.user_name, :count => item.count}]}]
    end
    def channel_messages
        if !get_server()
            render "stats/404"
            return
        end
        returned_data = MessagesByChannel.where(guild_id: "eq.#{@id}")
        @data = Hash[returned_data.collect {|item| [item.channel_id, {:name => item.channel_name, :count => item.count}]}]
    end
    
end
