class AddFcmRegistrationTokenToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :fcm_registration_token, :string
  end
end
