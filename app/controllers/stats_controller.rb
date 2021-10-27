require "groupdate"

class StatsController < ApplicationController
    def get_server
        @id = params[:id]

        server = Guild.where("id = #{@id}").first
        
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
    
    def format_word(word)
        word_formatted = word.downcase.gsub(/[^a-z0-9\s]+/, '')

        if word_formatted.match(/\d+/)
            return ""
        end

        word_formatted
    end

    def user_word_counts
        msgs = Message.where("guild_id = #{@id}")

        @word_count_by_user = {}
        @word_count_hash = {}

        msgs.each do |item|
            u_id = item.user_id
            if !@word_count_by_user.has_key?(u_id)
                @word_count_by_user[u_id] = {}
            end

            item.message.split() do |word|
                # Format the word
                word_formatted = format_word(word)

                if word_formatted.length() == 0
                    next
                end
                
                # Add to hash
                if !@word_count_hash.has_key?(word_formatted)
                    @word_count_hash[word_formatted] = 0
                end
                if !@word_count_by_user[u_id].has_key?(word_formatted)
                    @word_count_by_user[u_id][word_formatted] = 0
                end
                
                @word_count_hash[word_formatted] = @word_count_hash[word_formatted] + 1
                @word_count_by_user[u_id][word_formatted] = @word_count_by_user[u_id][word_formatted] + 1
            end
        end

    end

    def user_messages
        if !get_server()
            render "stats/404"
            return
        end
        
        # All users

        user_hash = Hash[User.all.map {|item| [item.id, item.user_name]}]

        # All user total counts

        totals_hash = Message.where("guild_id = #{@id}").group(:user_id).count
        
        # Users ordered by total count
        ordered_users = totals_hash.keys.sort_by {|u_id| -totals_hash[u_id]}
        
        # Total user messages
        @total_user_messages = ordered_users.map {|u_id| [user_hash[u_id], totals_hash[u_id]]}

        # Cumulative messages
        msg_day = Message.where("guild_id = #{@id}").group_by_day(:message_timestamp).group(:user_id).count
        all_days_unsorted = msg_day.keys.map {|i| i[0]}

        all_days = (all_days_unsorted.min..all_days_unsorted.max).map{|t| day_format(t)}.uniq


        # format:
        # {id => {date => count, date => count}, id => {date => count, date => count}}

        day_records_hash = {}

        msg_day.keys.each do |i|
            date = day_format(i[0])
            u_id = i[1]
            count = msg_day[i]

            if day_records_hash.keys.exclude?(u_id)
                day_records_hash[u_id] = {}
            end
            if day_records_hash[u_id].keys.exclude?(date)
                day_records_hash[u_id][date] = count
            end
            
        end

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
        msg_month = Message.where("guild_id = #{@id}").group_by_month(:message_timestamp).group(:user_id).count
        all_months_unsorted = msg_month.keys.map {|i| i[0]}

        all_months = (all_months_unsorted.min..all_months_unsorted.max).map{|t| month_format(t)}.uniq


        # format:
        # {id => {date => count, date => count}, id => {date => count, date => count}}

        month_records_hash = {}

        msg_month.keys.each do |i|
            date = month_format(i[0])
            u_id = i[1]
            count = msg_month[i]

            if month_records_hash.keys.exclude?(u_id)
                month_records_hash[u_id] = {}
            end
            if month_records_hash[u_id].keys.exclude?(date)
                month_records_hash[u_id][date] = count
            end
            
        end

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
        returned_data = Message.where("guild_id = #{@id}").group(:channel_id).count
        data_unsorted = returned_data.map {|c_id, count| [Channel.where("id = #{c_id}").first.channel_name, count]}
        @data = data_unsorted.sort_by {|item| -item[1]}
    end

    def top_words
        if !get_server()
            render "stats/404"
            return
        end

        user_word_counts()

        @word_counts = @word_count_hash.keys.sort_by {|w| -@word_count_hash[w]}.map {|w| [w, @word_count_hash[w]]}
    end

    def user_disproportionate_words
        if !get_server()
            render "stats/404"
            return
        end
        
        # All users
        user_hash = Hash[DiscordUser.all.map {|item| [item.user_id, item.user_name]}]
        
        # Users ordered by total count
        ordered_users = UserMessagesByGuild.where(guild_id: "eq.#{@id}")
                .sort_by {|item| -item.count}
                .map {|item| item.user_id}

        user_word_counts()

        @min_occurences = 5
        @max_to_show = 20

        @disproportionate_words = ordered_users.map { |u_id|
            [user_hash[u_id], 
            @word_count_by_user[u_id].keys
                .select {|w| @word_count_hash[w] >= @min_occurences}
                .map {|w| [w, 100.0 * @word_count_by_user[u_id][w].to_f / @word_count_hash[w].to_f]}
                .sort_by {|w| -w[1]}
                .take(@max_to_show)
            ]
        }.select {|item| item[1].length() >= 1}

    end
    
    def word_search
        if !get_server()
            render "stats/404"
            return
        end

        @search = params[:search]
        @total_occurences = 0

        if @search.nil?
            return
        end

        @search_formatted = format_word(@search)

        if @search_formatted.length() == 0
            return
        end

        # All users
        user_hash = Hash[DiscordUser.all.map {|item| [item.user_id, item.user_name]}]

        # Search for counts of word by user
        user_word_counts()
        
        if !@word_count_hash.has_key?(@search_formatted)
            return
        end
        
        @total_occurences = @word_count_hash[@search_formatted]

        # Create graph
        @user_word_count = @word_count_by_user.keys()
                .select { |u_id| @word_count_by_user[u_id].has_key?(@search_formatted)}
                .sort_by {|u_id| -@word_count_by_user[u_id][@search_formatted]}
                .map {|u_id| [user_hash[u_id], @word_count_by_user[u_id][@search_formatted]]}
    end
end
