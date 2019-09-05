class RenameFightColumns < ActiveRecord::Migration[5.1]
  def change
    rename_column :fights, :first_fighter, :first_fighter_id
    rename_column :fights, :second_fighter, :second_fighter_id
    rename_column :fights, :victor, :victor_id
  end
end
