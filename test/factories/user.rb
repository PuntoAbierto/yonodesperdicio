FactoryGirl.define do

  sequence :email do |n|
    "foo#{n}@example.com"
  end

  sequence :username do |n|
    "username#{n}"
  end

  factory :user do
    name "aaa"
    username
    email
    lang 'es'
    password '123456789'
    role 0
    woeid 766273
    zipcode 1111
    confirmed_at          Time.now
  end

  # This will use the User class (Admin would have been guessed)
  factory :admin, class: User do
    name "aaa"
    username
    email 'admin@gmail.com'
    lang 'es'
    password '12435968770'
    role 1
    zipcode 1111
    confirmed_at          Time.now
  end

  factory :non_confirmed_user, class: User do
    name "aaa"
    username
    email
    lang 'es'
    password '123456789'
    role 0
    woeid 766273
    zipcode 1111
  end

end
