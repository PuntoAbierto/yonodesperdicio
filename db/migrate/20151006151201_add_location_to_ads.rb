class AddLocationToAds < ActiveRecord::Migration
  def change
    add_column :ads, :zipcode, :string
    add_column :ads, :province, :string
    add_column :ads, :city, :string
  end
end
