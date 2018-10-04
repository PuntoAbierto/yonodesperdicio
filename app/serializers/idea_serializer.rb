class IdeaSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :category, :title, :introduction, :ingredients, :body, :image, :tag_list, :created_at, :updated_at
  has_one :user
  has_many :comments
end
