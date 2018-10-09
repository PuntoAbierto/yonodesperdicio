class AddOfferCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :offers_count, :integer, default: 0
  end
end
