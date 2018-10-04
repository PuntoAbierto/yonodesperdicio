class RemoveRailsPushNotificationsTables < ActiveRecord::Migration
  def change
  	drop_table :rails_push_notifications_apns_apps
  	drop_table :rails_push_notifications_gcm_apps
  	drop_table :rails_push_notifications_mpns_apps
  	drop_table :rails_push_notifications_notifications
  end
end
