# frozen_string_literal: true

class Api::OffersController < Api::BaseController
  # before_action :authenticate_with_token!, only: [:create, :update, :destroy]
  before_filter :offers, only: :index
  before_filter :offer, only: %i[show update destroy]
  respond_to :json

  def index
    render "offers/index"
  end

  def show
    render "offers/show"
  end

  def create
    @offer = Offer.new(offer_params)
    
    @offer.image = parse_image_data(params[:offer][:image]) if params[:offer][:image]
    if @offer.save
      render "offers/show", status: :created 
    else
      render json: @offer.errors, status: :unprocessable_entity
    end
  end

  def update
    if @offer.update(offer_params)
      render "offers/show", status: :accepted
    else
      render json: @offers.errors, status: :unprocessable_entity
    end
  end

  private

  def offer_params
    params.require(:offer).permit(:title, :description, :store, :address, :until, :image).merge(user_id: current_user.id)
  end

  def offers
    @offers ||= Offer.available.page(params[:page]).per(params[:per])
  end

  def offer
    @offer ||= Offer.friendly.find(params[:id])
  end


  def parse_image_data(image_data)
    filename = image_data[:filename]

    @tempfile = Tempfile.new(filename)
    @tempfile.binmode
    @tempfile.write Base64.decode64(image_data[:content])
    @tempfile.rewind

    uploaded_file = ActionDispatch::Http::UploadedFile.new(
      tempfile: @tempfile,
      filename: filename
    )

    uploaded_file.content_type = image_data[:content_type]
    uploaded_file
  end
end
