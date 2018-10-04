json.array!(@ads) do |ad|
  json.extract! ad, :title, :body, :user_id, :type, :woeid_code, :ip
  json.url ad_url(ad, format: :json)
end
