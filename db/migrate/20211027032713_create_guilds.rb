class CreateGuilds < ActiveRecord::Migration[6.1]
  def change
    create_table(:guilds, id: false) do |t|
      t.bigint :id, :options => 'PRIMARY KEY'
      t.string :guild_name

      t.timestamps
    end

    add_index :guilds, [:id], :unique => true
  end
end
