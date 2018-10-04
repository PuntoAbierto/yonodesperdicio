class Api::AdsController < Api::BaseController
  before_action :authenticate_with_token!, only: [:create, :update, :destroy]
  respond_to :json

  def index
    ads = Ad.api_search(params).page(params[:page]).per(params[:per_page])
    render json: ads, meta: pagination(ads, params[:per_page])
  end

  def show
    respond_with Ad.find(params[:id])
  end

  def create
    begin
      ad = Ad.new(ad_params)
      ad.image = parse_image_data(params[:ad][:image]) if params[:ad][:image]
      ad.user = current_user

      if ad.save
        render json: ad, status: 201, location: [:api, ad]
      else
        render json: { errors: ad.errors }, status: 422
      end
    ensure
      clean_tempfile
    end
  end

  def update
    begin
      ad = current_user.ads.find(params[:id])
      ad.image = parse_image_data(params[:ad].delete(:image)) if params[:ad][:image]

      if ad.update(ad_params)
        render json: ad, status: 200, location: [:api, ad]
      else
        render json: { errors: ad.errors }, status: 422
      end
    ensure
      clean_tempfile
    end
  end

  def destroy
    ad = current_user.ads.find(params[:id])
    ad.destroy
    head 204
  end

  private

  def ad_params
    params.require(:ad).
    permit(:title, :body, :type, :status,
      :grams, :expiration_date, :pick_up_date,
      :comments_enabled, :image,
      :zipcode, :city, :province,
      :food_category
      )
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

  def clean_tempfile
    if @tempfile
      @tempfile.close
      @tempfile.unlink
    end
  end
end
