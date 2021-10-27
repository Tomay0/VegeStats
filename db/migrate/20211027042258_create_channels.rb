class CreateChannels < ActiveRecord::Migration[6.1]
  def change
    create_table(:channels, id: false) do |t|
      t.bigint :id, :options => 'PRIMARY KEY'
      t.bigint :guild_id
      t.text :channel_name

      t.timestamps
    end

    add_index :channels, [:id], :unique => true
    add_foreign_key :channels, :guilds
  end
end
