class Api::UsersController < Api::BaseController
  before_action :authenticate_with_token!, :except => [:create]
  respond_to :json

  def show
    user = User.find(params[:id])
    if current_user && current_user.id == user.id
      render json: user, serializer: SessionUserSerializer
    else
      render json: user
    end
  end

  def create
    begin
      user = User.new(user_params)
      user.image = parse_image_data(params[:user][:image]) if params[:user][:image]

      if user.save
        render json: user, status: 201, location: [:api, user]
      else
        render json: { errors: user.errors }, status: 422
      end
    ensure
      clean_tempfile
    end
  end

  def update
    begin
      user = current_user
      user.image = parse_image_data(params[:user].delete(:image)) if params[:user][:image]

      if user.update(user_params)
        render json: user, status: 200, location: [:api, user]
      else
        render json: { errors: user.errors }, status: 422
      end
    ensure
      clean_tempfile
    end
  end

  def destroy
    current_user.destroy
    head 204
  end

  def rate
    user = User.find(params[:id])
    user.rate params[:score].to_f, current_user, "rating"
    head 201
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :username, :name, :zipcode, :city, :province, :image, :accept_mailing, :fcm_registration_token)
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
