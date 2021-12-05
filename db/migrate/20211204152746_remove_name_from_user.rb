class RemoveNameFromUser < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :name, :string
  end
end
