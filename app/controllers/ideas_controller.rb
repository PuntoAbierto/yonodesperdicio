class IdeasController < ApplicationController
  before_filter :authenticate_user!

  # GET /ideas
  def index
    @ideas = current_user.ideas
  end

  # GET /ideas/1
  def show
    @idea = current_user.ideas.friendly.find(params[:id])
  end

  # GET /ideas/new
  def new
    @idea = Idea.new
  end

  # GET /ideas/1/edit
  def edit
    @idea = current_user.ideas.friendly.find(params[:id])
  end

  # POST /ideas
  def create
    @idea = Idea.new(idea_params)
    @idea.user = current_user

    if @idea.save
      redirect_to my_idea_path(@idea), notice: 'Idea was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /ideas/1
  def update
    @idea = current_user.ideas.friendly.find(params[:id])

    if @idea.update(idea_params)
      redirect_to my_idea_path(@idea), notice: 'Idea was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /ideas/1
  def destroy
    @idea = current_user.ideas.friendly.find(params[:id])

    @idea.destroy
    redirect_to my_ideas_url, notice: 'Idea was successfully destroyed.'
  end

  private
    # Only allow a trusted parameter "white list" through.
    def idea_params
      params.require(:idea).permit(:category, :title, :introduction, 
                                   :ingredients, :body, :image, :tag_list)
    end
end
