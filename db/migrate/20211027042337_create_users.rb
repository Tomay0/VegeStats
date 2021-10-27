class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table(:users, id: false) do |t|
      t.bigint :id, :options => 'PRIMARY KEY'
      t.text :user_name

      t.timestamps
    end
    
    add_index :users, [:id], :unique => true
  end
end
