class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.references :championship

      t.timestamps
    end
    add_index :players, :championship_id
  end
end
