json.conversations @conversations do |conversation|
  json.id conversation.id
  json.subject conversation.subject
  json.created_at conversation.created_at
  json.updated_at conversation.updated_at
  json.thread_id conversation.thread_id
  # json.user_id conversation.receipts.where.not(receiver_id: current_user.id).first.receiver_id
  json.last_message_from do
    json.id conversation.last_message.sender.id
    json.username conversation.last_message.sender.username
    json.name conversation.last_message.sender.name
    json.avatar do
      %i[medium large original].each do |size|
        json.set! size, asset_url(conversation.last_message.sender.image.url(size))
      end
    end
  end

  json.last_message conversation.last_message.body
end
