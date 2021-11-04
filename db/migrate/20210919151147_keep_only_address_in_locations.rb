class KeepOnlyAddressInLocations < ActiveRecord::Migration[6.1]
  def change
    remove_column :locations, :zip_code
    remove_column :locations, :country_code
    remove_column :locations, :state
    remove_column :locations, :city
  end
end
