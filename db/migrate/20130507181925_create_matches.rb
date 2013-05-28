class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.references :championship
      t.datetime :start_time
      t.string :location
      t.string :result
      t.integer :winner_id

      t.timestamps
    end
    add_index :matches, :championship_id
  end
end
