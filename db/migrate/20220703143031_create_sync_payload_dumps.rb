class CreateSyncPayloadDumps < ActiveRecord::Migration[6.1]
  def change
    create_table :sync_payload_dumps do |t|
      t.jsonb :payload
      t.integer :processing_status, null: false
      t.references :map, null: false, foreign_key: true

      t.timestamps
    end
  end
end
