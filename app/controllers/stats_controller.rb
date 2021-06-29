class StatsController < ApplicationController
    def index
        @id = params[:id]
        @type = "None"
    end
    def user_messages
        @id = params[:id]
        @type = "Users"

        returned_data = Messages.where(guild_id: "eq.#{@id}")

        @data = Hash[returned_data.collect {|item| [item.user_id, {:name => item.user_name, :count => item.count}]}]

    end
    def channel_messages
        @id = params[:id]
        @type = "Channels"
    end
    
end
