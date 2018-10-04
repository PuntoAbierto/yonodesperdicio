class Article < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  acts_as_taggable # Alias for acts_as_taggable_on :tags

  CATEGORIES = ['noticia', 'iniciativa']

  has_many :comments, as: :commentable

  validates :title, :category, :body, :published_at, presence: true

  has_attached_file :image,
                     styles: {thumb: "100x100>",
                              medium: "400x225#",
                              fourthree: "400x300#",
                              large: "600x337.5>"},
                     :default_url => "propias/d_news_:style.png"
  validates_attachment :image,
                       content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
  validates_attachment_size :image, :in => 0.megabytes..1.megabytes

  before_validation(on: :create) do
    self.published_at = Time.now
  end
end

