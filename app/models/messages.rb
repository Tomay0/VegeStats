require 'active_resource'

class Messages < ActiveResource::Base
    self.site = ENV["POSTGREST_URL"]
    self.headers['Authorization'] = "Bearer #{ENV["POSTGREST_TOKEN"]}"
    self.include_format_in_path = false
    self.element_name = "usermessagesbyguild"

    def self.collection_name
        self.element_name
    end
end