require "messages"

class StatsController < ApplicationController
    def get_server
        @id = params[:id]
        server = DiscordGuilds.where(guild_id: "eq.#{@id}").first
        
        if server.nil?
            return false
        end

        @server_name = server.guild_name
        @action = params[:action]
        return true
    end

    def month_format(time)
        return time.strftime("%b %Y")
    end

    def day_format(time)
        return time.strftime("%e %b %Y")
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
        
        # Total user messages
        @total_user_messages = ordered_users.map {|u_id| [user_hash[u_id], totals_hash[u_id]]}

        # Cumulative messages
        msg_day = UserMessagesByDay.where(guild_id: "eq.#{@id}")

        min_day = msg_day.first.message_day.to_datetime
        max_day = msg_day.last.message_day.to_datetime
        all_days = (min_day..max_day).map{|t| day_format(t)}.uniq

        day_records_hash = Hash[msg_day.group_by(&:user_id).map { |u_id, transcripts| 
            [u_id, Hash[transcripts.map {|item| [day_format(item.message_day.to_datetime), item.count]}]]
        }]

        prev_day = Hash[ordered_users.map { |u_id| [u_id, 0]}]
        totals = Hash[ordered_users.map { |u_id| [u_id, {}]}]

        all_days.each do |day|
            ordered_users.each do |u_id|
                amount = prev_day[u_id] + (day_records_hash[u_id].has_key?(day) ? day_records_hash[u_id][day] : 0)
                totals[u_id][day] = amount
                prev_day[u_id] = amount
            end
        end

        @cumulative_messages = ordered_users.map { |u_id|
            {name: user_hash[u_id], data:totals[u_id]}
        }

        # Messages by month
        msg_month = UserMessagesByMonth.where(guild_id: "eq.#{@id}")
        
        min_month = msg_month.first.message_month.to_datetime
        max_month = msg_month.last.message_month.to_datetime
        all_months = (min_month..max_month).map{|t| month_format(t)}.uniq

        month_records_hash = Hash[msg_month.group_by(&:user_id).map { |u_id, transcripts| 
            [u_id, Hash[transcripts.map {|item| [month_format(item.message_month.to_datetime), item.count]}]]
        }]

        @messages_by_month = ordered_users.map { |u_id|
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

    def top_words
        if !get_server()
            render "stats/404"
            return
        end

        msgs = DiscordMessages.where(guild_id: "eq.#{@id}")

        word_count_hash = {}

        msgs.each do |item|
            item.message.split() do |word|
                word_formatted = word.downcase.gsub(/[^a-z0-9\s]+/, '')

                if word_formatted.length() == 0 || word_formatted.match(/\d+/)
                    next
                end

                if !word_count_hash.has_key?(word_formatted)
                    word_count_hash[word_formatted] = 0
                end
                
                word_count_hash[word_formatted] = word_count_hash[word_formatted] + 1
            end
        end

        @word_counts = word_count_hash.keys.sort_by {|w| -word_count_hash[w]}.map {|w| [w, word_count_hash[w]]}
    end
    
end
