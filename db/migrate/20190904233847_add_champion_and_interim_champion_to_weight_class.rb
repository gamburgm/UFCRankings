class AddChampionAndInterimChampionToWeightClass < ActiveRecord::Migration[5.1]
  def change
    add_column :weight_classes, :champion_id, :integer
    add_column :weight_classes, :interim_champion_id, :integer
    add_foreign_key :weight_classes, :fighters, column: :champion_id
    add_foreign_key :weight_classes, :fighters, column: :interim_champion_id
  end
end
