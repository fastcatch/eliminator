require 'test_helper'

class PlayersControllerTest < ActionController::TestCase
  def setup
    sign_in users(:MrX)
  end

  test "update action" do
    player = players(:player_1)

    put :update, id: player.id, player: {name: 'Somebody Else'}, championship_id: championships(:tournament)
    assert_equal 'Somebody Else', assigns(:player).name
    assert_redirected_to championship_player_path(id: assigns(:player).id, championship_id: championships(:tournament) )

    put :update, id: player.id, player: {name: 'Somebody Else in JSON'}, championship_id: championships(:tournament), format: 'json'
    assert_equal 'Somebody Else in JSON', assigns(:player).name
    assert_response 204

    # the X-editable way
    put :update, id: player.id,  name: 'name', value: 'Yet Sby Else', championship_id: championships(:tournament), format: 'json'
    assert_equal 'Yet Sby Else', assigns(:player).name
    assert_response 204
  end

end
