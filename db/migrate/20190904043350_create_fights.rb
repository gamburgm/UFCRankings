class CreateFights < ActiveRecord::Migration[5.1]
  def change
    create_table :fights do |t|
      t.date :date
      t.integer :first_fighter
      t.integer :second_fighter
      t.short :weight_class
      t.short :rounds
      t.integer :victor
      t.integer :method
      t.short :ending_round

      t.timestamps
    end
  end
end
