class UserSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :username, :image, :zipcode, :total_quantity, :rating, :created_at
end
