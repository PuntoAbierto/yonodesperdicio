require 'fcm'

module FCMPushNotifications
  extend ActiveSupport::Concern

  def self.message_sent(receipt)
    fcm = FCM.new(Rails.application.secrets["fcm_api_key"])

    message_recipients = receipt.message.receipts.where(mailbox_type: 'inbox').map(&:receiver)
    message_recipients_ids = message_recipients.map(&:id)
    Rails.logger.info "FCMPushNotifications: message_recipients: #{message_recipients_ids.inspect}"

    fcm_registration_ids = message_recipients.map(&:fcm_registration_token).compact

    if fcm_registration_ids.empty?
      Rails.logger.info "FCMPushNotifications: recipients (#{message_recipients_ids.inspect}) don't have fcm_registration_token"
      return
    end

    options = {
      data:
      {
        message_id: receipt.message.id,
        conversation: receipt.conversation.id,
        author_id: receipt.message.sender.id
      }
    }

    response = fcm.send(fcm_registration_ids, options)
    Rails.logger.info "FCMPushNotifications: response: #{response.inspect}"

    response
  end
end



