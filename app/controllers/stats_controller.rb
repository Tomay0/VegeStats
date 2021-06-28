class StatsController < ApplicationController
    def index
        @id = params[:id]
        @type = "None"
    end
    def user_messages
        @id = params[:id]
        @type = "Users"
    end
    def channel_messages
        @id = params[:id]
        @type = "Channels"
    end
end
