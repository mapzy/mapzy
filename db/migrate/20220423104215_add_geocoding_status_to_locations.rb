class AddGeocodingStatusToLocations < ActiveRecord::Migration[6.1]
  def change
    # Defaults to 0 (pending)
    add_column :locations, :geocoding_status, :integer, null: false, default: 0
    add_index :locations, :geocoding_status
  end
end
