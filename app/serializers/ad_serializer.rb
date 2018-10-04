class AdSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :title, :body, :status,
      :grams, :expiration_date, :pick_up_date,
      :comments_enabled, :image,
      :zipcode, :city, :province,
      :food_category,
      :created_at, :updated_at
  has_one :user
  has_many :comments
end
