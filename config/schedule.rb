# frozen_string_literal: true

every 1.hours do
  runner "Offer.expire"
end
