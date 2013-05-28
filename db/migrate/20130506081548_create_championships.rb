class CreateChampionships < ActiveRecord::Migration
  def change
    create_table :championships do |t|
      t.integer :user_id
      t.string :title
      t.integer :number_of_players

      t.timestamps
    end
    add_index :championships, :user_id, unique: false
  end
end
