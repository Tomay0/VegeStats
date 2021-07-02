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

    def month_format(time)
        return time.strftime("%b %Y")
    end

    def user_messages
        if !get_server()
            render "stats/404"
            return
        end
        
        # All users
        user_hash = Hash[DiscordUsers.all.map {|item| [item.user_id, item.user_name]}]

        # All user total counts
        totals_hash = Hash[UserMessagesByGuild.where(guild_id: "eq.#{@id}")
                .map {|item| [item.user_id, item.count]}]
        
        # Users ordered by total count - to be used by all 
        ordered_users = totals_hash.keys.sort_by {|u_id| -totals_hash[u_id]}

        @total_user_messages = ordered_users.map {|u_id| [user_hash[u_id], totals_hash[u_id]]}
        
        # Messages by month
        msg_month = UserMessagesByMonth.where(guild_id: "eq.#{@id}")
        
        min_month = msg_month.first.message_month.to_datetime
        max_month = msg_month.last.message_month.to_datetime
        all_months = (min_month..max_month).map{|t| month_format(t)}.uniq

        month_records_hash = Hash[msg_month.group_by(&:user_id).map { |u_id, transcripts| 
            [u_id, Hash[transcripts.map {|item| [month_format(item.message_month.to_datetime), item.count]}]]
        }]

        @messages_by_month = ordered_users.select {|u_id| month_records_hash.has_key?(u_id)}.map { |u_id|
            {name: user_hash[u_id], 
                data: Hash[all_months.map {
                    |mnth| [mnth, month_records_hash[u_id].has_key?(mnth)? month_records_hash[u_id][mnth] : 0]}]}
        }

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
