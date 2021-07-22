class LocationsMergeAddressLines < ActiveRecord::Migration[6.1]
  def change
    rename_column :locations, :address_line1, :address
    remove_column :locations, :address_line2
  end
end
