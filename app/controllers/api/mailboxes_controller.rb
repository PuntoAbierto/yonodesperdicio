class Api::MailboxesController < Api::BaseController
  before_action :authenticate_with_token!
  respond_to :json

  def show
    if params[:mailbox_id] == 'sent'
      mailbox = current_user.mailbox.sentbox
    elsif params[:mailbox_id] == 'trash'
      mailbox = current_user.mailbox.trash
    elsif params[:mailbox_id] == 'inbox'
      current_user.mailbox.inbox
    else
      current_user.mailbox.conversations
    end
    render json: mailbox
  end
end
