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
    def user_messages
        if !get_server()
            render "stats/404"
            return
        end
        returned_data = UserMessagesByGuild.where(guild_id: "eq.#{@id}")
        data_unsorted = returned_data.map {|item| [item.user_name, item.count]}
        @data = data_unsorted.sort_by {|item| -item[1]}
    end
    def channel_messages
        if !get_server()
            render "stats/404"
            return
        end
        returned_data = MessagesByChannel.where(guild_id: "eq.#{@id}")
        data_unsorted = returned_data.map {|item| [item.channel_name, item.count]}
        @data = data_unsorted.sort_by {|item| -item[1]}
    end
    
end
