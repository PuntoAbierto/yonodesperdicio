# frozen_string_literal: true

require 'fcm'

class NotificationWorker
  def initialize(resource, id)
    @resource = resource
    @id = id
  end

  def deliver(title, message)
    fcm = FCM.new(Rails.application.secrets["fcm_api_key"])
    registration_ids = User.registration_ids
    
    options = {
      notification: {
        title: title,
        body: message
      },
      data: {
        resource: @resource,
        id: @id
      }
    }

    registration_ids.each_slice(1000) do |ids|
      fcm.send(ids, options)
    end
  end
  handle_asynchronously :deliver, queue: 'notifications'
end
