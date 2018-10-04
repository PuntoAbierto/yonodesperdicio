require "test_helper"
include Warden::Test::Helpers

feature "CanAccessAdmin" do

  scenario "should not get /sidekiq as a anonymous user" do
    assert_raises(ActionController::RoutingError) { visit "/sidekiq" }
  end

  scenario "should not get /sidekiq as a normal user" do
    @user = FactoryGirl.create(:user)
    login_as @user
    assert_raises(ActionController::RoutingError) { visit "/sidekiq" }
  end

  scenario "should get /sidekiq as admin" do
    @admin = FactoryGirl.create(:admin)
    login_as @admin
    visit "/sidekiq"
    page.must_have_content "Sidekiq"
    page.must_have_content "Redis"
    page.must_have_content "Memory Usage"
  end

end
