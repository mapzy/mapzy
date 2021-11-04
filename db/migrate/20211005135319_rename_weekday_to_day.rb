class RenameWeekdayToDay < ActiveRecord::Migration[6.1]
  def change
    rename_column :opening_times, :weekday, :day
  end
end
