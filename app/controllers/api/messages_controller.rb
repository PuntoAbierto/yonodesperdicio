class Api::MessagesController < Api::BaseController
  include FCMPushNotifications

  before_action :authenticate_with_token!
  respond_to :json

  def index
    mailbox = set_mailbox
    messages = mailbox.find(params[:conversation_id]).messages.page(params[:page]).per(params[:per_page])
    render json: messages, meta: pagination(messages, params[:per_page])
  end

  def show
    mailbox = set_mailbox
    respond_with current_user.mailbox.conversations.find(params[:conversation_id])
  end

  def create
    conversation = current_user.mailbox.conversations.find(params[:conversation_id])

    if receipt = current_user.reply_to_conversation(conversation, params[:message][:body])
      FCMPushNotifications.message_sent(receipt)
      render json: receipt
    else
      render json: { errors: receipt.errors }, status: 422
    end
  end

  def new_message
    recipient = User.find(params[:recipient_id])
    if receipt = current_user.send_message(recipient, params[:message][:body], params[:message][:subject])
      render json: receipt.message
    else
      render json: { errors: receipt.errors }, status: 422
    end
  end

  private

  def message_params
    params.require(:message).
    permit(:subject, :body)
  end

  def set_mailbox
    if params[:mailbox_id] == 'sent'
      current_user.mailbox.sentbox
    elsif params[:mailbox_id] == 'trash'
      current_user.mailbox.trash
    elsif params[:mailbox_id] == 'inbox'
      current_user.mailbox.inbox
    else
      current_user.mailbox.conversations
    end
  end
end
