class AddExternalIdToLocation < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :external_id, :string
    add_index :locations, [:external_id, :map_id], unique: true
  end
end
