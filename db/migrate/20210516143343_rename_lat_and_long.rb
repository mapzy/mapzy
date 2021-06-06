class RenameLatAndLong < ActiveRecord::Migration[6.1]
  def change
    rename_column :locations, :lat, :latitude
    rename_column :locations, :long, :longitude
  end
end
