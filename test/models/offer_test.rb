require "test_helper"

class OfferTest < ActiveSupport::TestCase
  def offer
    @offer ||= Offer.new
  end

  def test_valid
    assert offer.valid?
  end
end
