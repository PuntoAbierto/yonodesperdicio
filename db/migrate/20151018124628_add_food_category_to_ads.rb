class AddFoodCategoryToAds < ActiveRecord::Migration
  def change
    add_column :ads, :food_category, :string
  end
end
