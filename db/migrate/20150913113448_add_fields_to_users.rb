class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :zipcode, :string
    add_column :users, :province, :string
    add_column :users, :city, :string
    add_column :users, :accept_mailing, :boolean
  end
end
