class Api::IdeasController < Api::BaseController
  before_action :authenticate_with_token!, only: [:create, :update, :destroy]
  respond_to :json

  def index
    ideas = Idea.api_search(params).page(params[:page]).per(params[:per_page])
    render json: ideas, meta: pagination(ideas, params[:per_page])
  end

  def show
    respond_with Idea.find(params[:id])
  end

  def create
    idea = Idea.new(idea_params)
    idea.user = current_user
    if idea.save
      render json: idea, status: 201, location: [:api, idea]
    else
      render json: { errors: idea.errors }, status: 422
    end
  end

  def update
    idea = current_user.ideas.find(params[:id])

    if idea.update(idea_params)
      render json: idea, status: 200, location: [:api, idea]
    else
      render json: { errors: idea.errors }, status: 422
    end
  end

  def destroy
    idea = current_user.ideas.find(params[:id])
    idea.destroy
    head 204
  end

  private

  def idea_params
    params.require(:idea).permit(:category, :title, :introduction,
                                 :ingredients, :body, :image, :tag_list)
  end
end
