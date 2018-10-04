class CommentSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :body, :created_at, :updated_at, :user_id
end
