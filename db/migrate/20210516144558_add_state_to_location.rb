class AddStateToLocation < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :state, :string
  end
end
