class Api::SessionsController < Api::BaseController
  respond_to :json

  def create
    password = params[:password]
    username = params[:username]
    user = User.find_by(username: username)

    if user && user.valid_password?(password)
      sign_in user, store: false
      user.generate_authentication_token!
      user.save
      render json: user, serializer: SessionUserSerializer, status: 200, location: [:api, user]
    else
      render json: { errors: "Invalid username or password" }, status: 422
    end
  end

  def destroy
    user = User.find_by(auth_token: params[:id])
    user.generate_authentication_token!
    user.save
    head 204
  end
end
