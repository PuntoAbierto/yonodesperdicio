class SessionUserSerializer < ActiveModel::Serializer
  attributes :id, :username, :total_quantity, :rating, :image, :zipcode, :city, :province, :email, :auth_token, :created_at, :fcm_registration_token
end
