class MergeStreetNameAndNumber < ActiveRecord::Migration[6.1]
  def change
    remove_column :locations, :street_number
    rename_column :locations, :street_name, :addres_line_1
    add_column :locations, :street_number, :string
  end
end
