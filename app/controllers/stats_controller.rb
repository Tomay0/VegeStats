require "messages"

class StatsController < ApplicationController
    def index
        @id = params[:id]
        @type = "None"
    end
    def user_messages
        @id = params[:id]
        returned_data = UserMessagesByGuild.where(guild_id: "eq.#{@id}")
        @data = Hash[returned_data.collect {|item| [item.user_id, {:name => item.user_name, :count => item.count}]}]
    end
    def channel_messages
        @id = params[:id]
        returned_data = MessagesByChannel.where(guild_id: "eq.#{@id}")
        @data = Hash[returned_data.collect {|item| [item.channel_id, {:name => item.channel_name, :count => item.count}]}]
    end
    
end
