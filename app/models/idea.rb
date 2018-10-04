class Idea < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  acts_as_taggable # Alias for acts_as_taggable_on :tags

  CATEGORIES = ['trucos', 'recetas']

  belongs_to :user
  has_many :comments, as: :commentable

  validates :title, :category, :introduction, :body, :user_id, :published_at, presence: true

  validates :title, length: {minimum: 5, maximum: 200}
  validates :introduction, length: {minimum: 10, maximum: 500}
  validates :body, length: {minimum: 10}

  has_attached_file :image,
                    styles: {thumb: "100x100>",
                             medium: "400x225#",
                             fourthree: "400x300#",
                             large: "600x337.5>"},
                    :default_url => "propias/d_brick_:style.png"
  validates_attachment :image,
                       content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
  validates_attachment_size :image, :in => 0.megabytes..1.megabytes

  before_validation(on: :create) do
    self.published_at = Time.now
  end

  def self.api_search(params)
    category = params[:category]
    user_id = params[:user_id]

    r = Idea.where("published_at < ?", Time.now)
    r = r.where("category = ?", category) if category.present?
    r = r.where("user_id = ?", user_id) if user_id.present?
    r.order('published_at DESC')
  end

  def self.search(query)
    r = Idea
    r = r.where("title LIKE ?", "%#{query}%")
    r
  end
  

end
