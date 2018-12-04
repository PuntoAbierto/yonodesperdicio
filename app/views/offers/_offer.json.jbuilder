json.id offer.id
json.title offer.title
json.description offer.description
json.address offer.address
json.store offer.store
json.until offer.until
json.status offer.status
json.user_id offer.user.id
json.image do
  %i[medium large original].each do |size|
    json.set! size, asset_url(offer.image.url(size))
  end
end
