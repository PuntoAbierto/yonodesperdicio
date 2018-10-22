# frozen_string_literal: true

class OffersController < ApplicationController
  before_filter :offers, only: :index
  before_filter :offer, only: %i[show edit update destroy]
  load_and_authorize_resource

  # GET /offers || /offers.json
  def index; end

  # GET /offers/:id || /offers/:id.json
  def show; end

  # GET /offers/new
  def new
    @offer = Offer.new
  end

  # POST /offers || /offers.json
  def create
    @offer = Offer.new(offer_params)
    respond_to do |format|
      # if verify_recaptcha(model: @offer, message: t('nlt.captcha_error')) && @offer.save
      if @offer.save
        format.html { redirect_to @offer, notice: t('nlt.offers.created') }
        format.json { render action: "show", status: :created }
      else
        format.html { render "new" }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /offers/:id/edit
  def edit; end

  # PATCH /offers/:id || /offers/:id.json
  def update    
    respond_to do |format|
      if @offer.update(offer_params)
        format.html { redirect_to @offer, notice: t('nlt.offers.edited') }
        format.json { render action: "show", status: :created }
      else
        format.html { render "edit" }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if can?(:destroy, @offer)
      @offer.destroy!
      flash[:success] = "Oferta eliminada exitosamente"
      redirect_to request.referrer
    else
      flash[:alert] = "No estás autorizado para eliminar esta oferta"
      redirect_to :root
    end
  end

  private

  def offers
    @offers ||= Offer.available.
                           page(params[:page]).per(12)
  end

  def offer
    @offer ||= Offer.friendly.find(params[:id])
  end

  def offer_params
    params.require(:offer).permit(:title, :address, :description, :until, :store, :image).merge(user_id: current_user.id)
  end
end
