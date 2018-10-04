class AddFieldToAds < ActiveRecord::Migration
  def change
    add_column :ads, :grams, :integer
    add_column :ads, :expiration_date, :date
    add_column :ads, :pick_up_date, :date
  end
end
