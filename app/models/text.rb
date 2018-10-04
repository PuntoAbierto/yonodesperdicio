class Text < ActiveRecord::Base
  validates :title, :body, :code, :published_at, presence: true

   before_validation(on: :create) do
    self.published_at = Time.now
  end
end
