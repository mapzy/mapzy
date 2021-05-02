class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations do |t|
      t.string :name
      t.text :description
      t.string :street_number
      t.string :street_name
      t.string :city
      t.string :zip_code
      t.string :country_code
      t.decimal :lat, precision: 15, scale: 10
      t.decimal :long, precision: 15, scale: 10
      t.references :map, null: false, foreign_key: true

      t.timestamps
    end
  end
end
