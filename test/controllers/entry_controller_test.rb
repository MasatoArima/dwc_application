require 'test_helper'

class EntryControllerTest < ActionDispatch::IntegrationTest
  test "should get user" do
    get entry_user_url
    assert_response :success
  end

  test "should get room" do
    get entry_room_url
    assert_response :success
  end

end
