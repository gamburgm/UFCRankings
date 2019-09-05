class CreateWeightClasses < ActiveRecord::Migration[5.1]
  def change
    create_table :weight_classes do |t|
      t.string :name
      t.integer :weight

      t.timestamps
    end
  end
end
