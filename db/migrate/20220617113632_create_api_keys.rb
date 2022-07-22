class CreateApiKeys < ActiveRecord::Migration[6.1]
  def change
    create_table :api_keys do |t|
      t.string :key_value
      t.references :map, null: false, foreign_key: true

      t.timestamps

      t.index :key_value, unique: true
    end

    Rake::Task["mapzy:migration:add_api_key_to_maps"].invoke
  end
end
