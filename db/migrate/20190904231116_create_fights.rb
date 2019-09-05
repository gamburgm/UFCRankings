class CreateFights < ActiveRecord::Migration[5.1]
  def change
    create_table :fights do |t|
      t.date :date
      t.integer :event_id
      t.integer :first_fighter
      t.integer :second_fighter
      t.integer :weight_class_id
      t.integer :rounds
      t.integer :victor
      t.integer :method
      t.integer :ending_round

      t.timestamps
    end

    add_foreign_key :fights, :fighters, column: :first_fighter
    add_foreign_key :fights, :fighters, column: :second_fighter
    add_foreign_key :fights, :fighters, column: :victor
    add_foreign_key :fights, :weight_classes
    add_foreign_key :fights, :events
  end
end
