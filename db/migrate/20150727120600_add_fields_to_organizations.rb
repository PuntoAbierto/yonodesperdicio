class AddFieldsToOrganizations < ActiveRecord::Migration

  def self.up
    add_column :organizations, :email, :string
    add_column :organizations, :phone, :string
    add_column :organizations, :website, :string
  end

end
