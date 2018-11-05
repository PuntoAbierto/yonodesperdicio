# encoding : utf-8
class Ad < ActiveRecord::Base

  after_create :send_notification
  require 'ipaddress'

  FOOD_CATEGORIES = [
    'carne y aves',
    'pescado y marisco',
    'fruta',
    'verduras y hortalizas',
    'charcutería',
    'lácteos',
    'legumbres',
    'bebidas',
    'condimentos',
    'pan y bollería',
    'conservas',
    'platos preparados',
    'frutos secos',
    'lote variado'
  ]

  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :user, :counter_cache => true

  has_many :comments, as: :commentable

  validates :title, presence: true
  validates :body, presence: true
  validates :user_id, presence: true
  validates :grams, presence: true
  validates :food_category, presence: true

  validates :title, length: {minimum: 5, maximum: 100},
            presence: true

  validates :body, length: {minimum: 10, maximum: 500}

  validates :status,
    inclusion: { in: [1, 2, 3], message: "no es un estado válido" },
    presence: true

  validates :type,
    inclusion: { in: [1, 2], message: "no es un tipo válido" },
    presence: true

  #validate :valid_ip_address

  # legacy database: has a column with value "type", rails doesn't like that
  # the "type" column is no longer need it by rails, so we don't care about it
  self.inheritance_column = nil

  default_scope { order('ads.created_at DESC') }

  acts_as_paranoid

  has_attached_file :image,
                    styles: {thumb: "100x100>",
                             medium: "400x225#",
                             fourthree: "400x300#",
                             large: "600x337.5>"},
                    :default_url => "propias/d_ads_:style.png",
                    process_in_background: :image

  validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

  validates_attachment_size :image, :in => 0.megabytes..1.megabytes

  before_validation do
    self.type = 1 unless self.type.present?

    self.zipcode = user.zipcode unless self.zipcode.present?
    self.city = user.city unless self.city.present?
    self.province = user.province unless self.province.present?
  end

  scope :give, -> { where(type: 1) }
  scope :want, -> { where(type: 2) }

  scope :by_type, lambda {|type|
    return scope unless type.present?
    where('type = ?', type)
  }

  scope :available, -> { where(status: 1) }
  scope :booked, -> { where(status: 2) }
  scope :delivered, -> { where(status: 3) }

  scope :by_status, lambda {|status|
    return all unless status.present?
    where('status = ?', status)
  }

  scope :by_woeid_code, lambda {|woeid_code|
    return all unless woeid_code.present?
    where('woeid_code = ?', woeid_code)
  }

  def body
    ApplicationController.helpers.escape_privacy_data(read_attribute(:body))
  end

  def title
    ApplicationController.helpers.escape_privacy_data(read_attribute(:title))
  end

  def readed_counter
    readed_count || 1
  end

  def increment_readed_count!
    # Is this premature optimization?
    # AdIncrementReadedCountWorker.new(self.id)
    Ad.increment_counter(:readed_count, self.id)
  end

  def woeid_name
    city
  end

  def woeid_name_short
    city
  end

  def full_title
    self.type_string + " segunda mano " + self.title + ' ' + self.woeid_name
  end

  def type_string
    case type
    when 1
      I18n.t('nlt.give')
    when 2
      I18n.t('nlt.want')
    else
      I18n.t('nlt.give')
    end
  end

  def type_class
    case type
    when 1
      "give"
    when 2
      "want"
    else
      "give"
    end
  end

  def status_class
    case status
    when 1
      'available'
    when 2
      'booked'
    when 3
      'delivered'
    else
      'available'
    end
  end

  def status_string
    case status
    when 1
      I18n.t('nlt.available')
    when 2
      I18n.t('nlt.booked')
    when 3
      I18n.t('nlt.delivered')
    else
      I18n.t('nlt.available')
    end
  end

  def valid_ip_address
    unless IPAddress.valid?(ip)
      errors.add(:ip, "No es una IP válida")
    end
  end

  def is_give?
    type == 1
  end

  def is_want?
    type == 2
  end

  def meta_title
    "#{I18n.t('nlt.keywords')} #{self.title} #{self.woeid_name}"
  end

  def self.search(query, zipcode, food_category)
    r = Ad
    r = r.where("ads.title like ? OR ads.body LIKE ? OR ads.grams = ?", "%#{query}%","%#{query}%",query) if query.present?
    r = r.where("ads.zipcode LIKE ?", "%#{zipcode}%") if zipcode.present?
    r = r.where("ads.food_category = ?", food_category) if food_category.present?
    r
  end

  def self.api_search(params)
    query = params[:query]
    zipcode = params[:zipcode]
    food_category = params[:food_category]
    user_id = params[:user_id]
    status = params[:status]

    r = Ad
    r = r.where("ads.title like ? OR ads.body LIKE ? OR ads.grams = ?", "%#{query}%","%#{query}%",query) if query.present?
    r = r.where("ads.zipcode LIKE ?", "%#{zipcode}%") if zipcode.present?
    r = r.where("ads.food_category = ?", food_category) if food_category.present?
    r = r.where("ads.user_id = ?", user_id) if user_id.present?
    r = r.where("ads.status = ?", status) if status.present?
    r
  end

  private

  def send_notification
    NotificationWorker.new("alimento", id).deliver(
      "Nuevo alimento compartido",
      "#{user.username} ha compartido un nuevo alimento que te puede interesar"
    )
  end

end
