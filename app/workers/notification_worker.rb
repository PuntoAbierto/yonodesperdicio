class NotificationWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'notifications'

  def perform(title, message)

  end
end
