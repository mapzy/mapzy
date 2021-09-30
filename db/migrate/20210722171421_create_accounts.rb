class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :stripe_customer_id
      t.integer :status, null: false, default: 0
      t.datetime :trial_end_date, null: false, default: -> { "now() + interval '2 week' " }

      t.timestamps
    end
  end
end
