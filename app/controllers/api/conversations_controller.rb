class Api::ConversationsController < Api::BaseController
  before_action :authenticate_with_token!
  respond_to :json

  def index
    mailbox = set_mailbox
    conversations = mailbox
    render json: conversations
  end

  def show
    mailbox = set_mailbox
    conversation = mailbox.find(params[:id])
    render json: conversation
  end

  private

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
