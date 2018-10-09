json.total_offers @offers.total_count
json.pages @offers.total_pages
json.offers @offers, partial: "offers/offer", as: :offer

