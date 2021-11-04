class CreateOpeningTimes < ActiveRecord::Migration[6.1]
  def change
    create_table :opening_times do |t|
      t.integer :weekday, null: false
      t.time :opening_time
      t.time :closing_time
      t.boolean :open_24h, null: false, default: false

      t.timestamps
    end

    add_reference :opening_times, :location, foreign_key: true, index: true
    add_index :opening_times, [:weekday, :location_id], unique: true
  end
end