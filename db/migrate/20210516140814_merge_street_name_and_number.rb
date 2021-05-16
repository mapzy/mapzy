class MergeStreetNameAndNumber < ActiveRecord::Migration[6.1]
  def change
    remove_column :locations, :street_number, :string
    rename_column :locations, :street_name, :address_line_1
    add_column :locations, :address_line_2, :string
  end
end
