FactoryGirl.define do
  factory :idea do
    title "MyString"
    body "MyText"
    category "MyString"
    published_at "2015-07-11 18:18:24"
    user
  end

end
