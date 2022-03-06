class AddShopifyFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :shopify_domain, :string
    add_column :users, :shopify_token, :string
    add_column :users, :shopify_access_scopes, :string

    add_index :users, :shopify_domain, unique: true
  end
end
