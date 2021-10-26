class DiscordMessage < ActiveRecord::Base
  self.abstract_class = true
end

class DiscordGuild < ActiveRecord::Base
  self.abstract_class = true
end

class DiscordChannel < ActiveRecord::Base
  self.abstract_class = true
end

class DiscordUser < ActiveRecord::Base
  self.abstract_class = true
end

class UserMessagesByMonth < ActiveRecord::Base
  self.abstract_class = true
end
class MessagesByChannel < ActiveRecord::Base
  self.abstract_class = true
end
class DiscordUsers < ActiveRecord::Base
  self.abstract_class = true
end
class UserMessagesByGuild < ActiveRecord::Base
  self.abstract_class = true
end