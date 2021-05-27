class LocationsRenameAddressLines < ActiveRecord::Migration[6.1]
  def change
    rename_column :locations, :address_line_1, :address_line1
    rename_column :locations, :address_line_2, :address_line2
  end
end
