class AddClosedToOpeningTimes < ActiveRecord::Migration[6.1]
  def change
    add_column :opening_times, :closed, :boolean, null: false, default: false
  end
end
