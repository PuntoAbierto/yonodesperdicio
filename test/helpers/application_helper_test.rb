require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  test "should escape_privacy_data" do
    text = "si hay interés, por favor, contactar por email example@example.com, por sms 999999999, o whatsapp al 666666666"
    expected_text = "si hay interés, por favor, contactar por email  , por sms  , o whatsapp al  "
    assert_equal(escape_privacy_data(text), expected_text)
  end

  test "should cache_key_for" do
    result1 = cache_key_for "123", User.new
    result2 = cache_key_for "123", User.new
    assert_equal result1, result2
    assert_equal "f97ead06c958e1e778e65e99d7de7f67", result1
    assert_equal "f97ead06c958e1e778e65e99d7de7f67", result2

    result3 = cache_key_for "123", FactoryGirl.create(:user)
    result4 = cache_key_for "123", FactoryGirl.create(:admin)
    assert_not_equal result3, result4
    assert_equal "f97ead06c958e1e778e65e99d7de7f67", result3
    assert_equal "38ed13109ed92bc1eb89b82c8345ed01", result4
  end

end
