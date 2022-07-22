class AddSyncModeToMap < ActiveRecord::Migration[6.1]
  def change
    add_column :maps, :sync_mode, :boolean, null: false, default: false
  end
end
