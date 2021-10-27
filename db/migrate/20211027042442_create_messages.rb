class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table(:messages, id: false) do |t|
      t.bigint :id, :options => 'PRIMARY KEY'
      t.bigint :guild_id
      t.bigint :channel_id
      t.bigint :user_id
      t.text :message
      t.timestamp :message_timestamp

      t.timestamps
    end
    
    add_index :messages, [:id], :unique => true
    add_foreign_key :messages, :channels
    add_foreign_key :messages, :users
    add_foreign_key :messages, :guilds
  end
end
