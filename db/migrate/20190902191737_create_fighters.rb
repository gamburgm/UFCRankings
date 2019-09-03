class CreateFighters < ActiveRecord::Migration[5.1]
  def change
    create_table :fighters do |t|
      t.string :first_name
      t.string :last_name
      t.string :nickname, default: ""
      t.date :debut
      t.integer :wins, default: 0
      t.integer :losses, default: 0
      t.integer :draws, default: 0
      t.boolean :active, default: false
      t.integer :age
      t.integer :height
      t.integer :reach
      t.integer :elo

      t.timestamps
    end
  end
end
