class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true


  validates :body, presence: true
  validates :user_id, presence: true
  validates :commentable_id, presence: true
  validates :commentable_type, presence: true
end
