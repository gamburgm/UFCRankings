class AddUniqueIndexToFighters < ActiveRecord::Migration[5.1]
  def change
    add_index :fighters, [ :first_name, :last_name, :debut ], unique: true
  end
end
