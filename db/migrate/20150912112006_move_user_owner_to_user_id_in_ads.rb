class MoveUserOwnerToUserIdInAds < ActiveRecord::Migration
  def change
    rename_column :ads, :user_owner, :user_id
  end
end
