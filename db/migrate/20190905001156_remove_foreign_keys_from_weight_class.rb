class RemoveForeignKeysFromWeightClass < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :weight_classes, column: :champion_id
    remove_foreign_key :weight_classes, column: :interim_champion_id
  end
end
