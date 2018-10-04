class Organization < ActiveRecord::Base

  ratyrate_rateable "rating"

  validates :name, :description, :zipcode, :address, presence: true

  #has_attached_file :image, styles: {thumb: "100x100>", medium: "400x230#", large: "530x300>"}
  #validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
  #validates_attachment_size :image, :in => 0.megabytes..1.megabytes

  extend FriendlyId
  friendly_id :name, use: :slugged

  def self.search(query)
    where("zipcode like ?", "%#{query}%")
  end

end
