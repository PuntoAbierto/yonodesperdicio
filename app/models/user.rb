class User < ActiveRecord::Base

  has_many :ads
  has_many :ideas
  has_many :offers

  has_many :friendships
  has_many :friends, :through => :friendships

  before_save :default_lang
  before_create :generate_authentication_token!

  has_many :legacy_sent_messages, :class_name=> 'Legacy::Message', :foreign_key=>'user_from', :dependent=>:destroy
  has_many :legacy_recieved_messages, :class_name=> 'Legacy::Message', :foreign_key=>'user_to', :dependent=>:destroy

  validates :username,
    uniqueness: true,
    presence: true,
    length: { minimum: 3 }

  validates :name, :zipcode, presence: true

  has_attached_file :image, styles: {thumb: "100x100#", medium: "150x150#"}, :default_url => 'propias/avatar_:style.png'
  validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
  validates_attachment_size :image, :in => 0.megabytes..1.megabytes

  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :confirmable, :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :lockable

  acts_as_messageable

  ratyrate_rater
  ratyrate_rateable "rating"

  scope :registration_ids, -> { pluck(:fcm_registration_token).compact }

  def to_s
    username
  end

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end

  def mailboxer_email(object)
    email
  end

  def unread_messages_count
    self.mailbox.inbox.unread(self).count
  end

  def admin?
    role == 1
  end

  #this method is called by devise to check for "active" state of the model
  def active_for_authentication?
    super and self.locked != 1
  end

  def unlock!
    self.update_column('locked', 0)
  end

  def lock!
    self.update_column('locked', 1)
  end

  def default_lang
    self.lang ||= "es"
  end

  def is_friend? user
    self.friends.where(id: user.id).count > 0 ? true : false
  end

  def total_quantity
    ads.give.delivered.sum(:grams)
  end

  def rating
    ratings = Rate.where(rateable: self).pluck('stars')
    (ratings.reduce(:+).to_f / ratings.size).round(1) if ratings.any?
  end
end
