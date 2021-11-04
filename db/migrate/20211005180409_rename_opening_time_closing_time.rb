class RenameOpeningTimeClosingTime < ActiveRecord::Migration[6.1]
  def change
    rename_column :opening_times, :opening_time, :opens_at
    rename_column :opening_times, :closing_time, :closes_at
  end
end
