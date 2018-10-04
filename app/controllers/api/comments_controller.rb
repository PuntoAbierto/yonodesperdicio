class Api::CommentsController < Api::BaseController
  before_action :authenticate_with_token!
  respond_to :json

  def create
    if params[:ad_id]
      commentable = Ad.find(params[:ad_id])
    elsif params[:idea_id]
      commentable = Idea.find(params[:idea_id])
    end

    comment = commentable.comments.build(comment_params)
    comment.user = current_user
    if comment.save
      render json: comment
    else
      render json: { errors: comment.errors }, status: 422
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
