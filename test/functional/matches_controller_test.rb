require 'test_helper'

class MatchesControllerTest < ActionController::TestCase
  def setup
    sign_in users(:MrX)
  end

  test "update action" do
    match = matches(:semifinal_1)

    put :update, id: match.id, match: {location: 'Elsewhere'}, championship_id: championships(:tournament)
    assert_equal 'Elsewhere', assigns(:match).location
    assert_redirected_to edit_championship_path(assigns(:match).championship)

    put :update, id: match.id, match: {location: 'Elsewhere in JSON'}, championship_id: championships(:tournament), format: 'json'
    assert_equal 'Elsewhere in JSON', assigns(:match).location
    assert_response :success
  end

end
