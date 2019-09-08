class RemoveUnnecessaryColumns < ActiveRecord::Migration[5.1]
  def change
    add_column :fighters, :href, :string
    change_column :fighters, :height, :decimal
    change_column :fighters, :reach, :decimal
    change_column :fighters, :elo, :decimal
    remove_index :fighters, name: :index_fighters_on_first_name_and_last_name_and_debut
    add_index :fighters, :href, unique: true

    remove_column :fights, :method
    remove_column :fights, :rounds
    remove_column :fights, :ending_round

    remove_column :fighters, :nickname
  end
end
