class AddSlugsToAds < ActiveRecord::Migration
  def change
  	add_column :ads, :slug, :string, unique: true
  end
end

