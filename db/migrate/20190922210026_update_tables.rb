class UpdateTables < ActiveRecord::Migration[5.1]
  def change
    remove_column :fighters, :first_name, :string
    remove_column :fighters, :last_name, :string
    add_column :fighters, :name, :string

    remove_column :weight_classes, :champion_id, :int
    remove_column :weight_classes, :interim_champion_id, :int

    remove_column :events, :type, :int
    add_column :events, :href, :string

    add_column :fights, :fight_id, :string
  end
end
