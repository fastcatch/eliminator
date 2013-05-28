class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.references :championship
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.references :content, :polymorphic => true

      t.timestamps
    end
    add_index :nodes, :championship_id, unique: false
  end
end
