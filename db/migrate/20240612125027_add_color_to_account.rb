class AddColorToAccount < ActiveRecord::Migration[7.1]
  def change
    add_column :maps, :custom_color, :string, null: false, default: "#e74d67"
    add_column :maps, :custom_accent_color, :string, null: false, default: "#f99b46"
  end
end
