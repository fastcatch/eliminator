require 'test_helper'

class ChampionshipsControllerTest < ActionController::TestCase
  def setup
    sign_in users(:MrX)
  end

  test "index action" do
    get :index
    assert_response :success
  end

  test "show action" do
    get :show, {'id' => championships(:tournament)}
    assert_response :success
  end

  test "tree markup" do
    championship = championships(:tournament)
    get :show, {'id' => championship}
    assert_response :success

    assert_select 'h1', championship.title

    assert_select '.championship', 1
    assert_select '.championship' do
      assert_equal 8, css_select('li a div.player').count, 'Invalid number of players'
      assert_equal 7, css_select('li a div.match').count, 'Invalid number of matches'
      assert_equal 5, css_select('li a div.match.played').count, 'Invalid number matches marked "played"'
      assert_select 'ul li' do |blocks|
        blocks.shift    # drop outermost block because that's special
        blocks.each do |block|
          assert_equal 2, css_select('ul>li').count, 'Invalid number of branches'
        end
      end
    end
  end

  test "new action" do
    get :new
    assert_response :success
    assert_select 'h3', 'New Championship'
    assert_select 'form', 1
  end

  test "create action" do
    assert_difference('Championship.count', 1) do
      post :create, championship: {title: 'Test Championship', number_of_players: 4}
      assert_redirected_to edit_championship_path(assigns(:championship).id)
    end
    assert_difference('Championship.count', 0) do
      post :create, championship: {title: 'Failing Test Championship', number_of_players: 0}
      assert_response :success
      assert_template :new
    end
  end

  test "edit action" do
    get :edit, id: championships(:tournament)
    assert_response :success
    assert_select 'h1', championships(:tournament).title
    assert_equal 1, css_select('h1 .js-x-editable').count, 'Title not in-place editable'
    assert css_select('.championship form').count > 0, 'Edit forms are not rendered'
  end

  test "update action" do
    post :create, championship: {title: 'Test Championship for Update', number_of_players: 4}
    assert_redirected_to edit_championship_path(assigns(:championship).id)
    put :update, id: assigns(:championship).id, championship: {title: 'Test Championship X'}
    assert_response 200
    assert_equal 'Test Championship X', assigns(:championship).title

    put :update, id: assigns(:championship).id, name: "title", value: 'Test Championship Y', format: :json       # the X-editable way
    assert_response 200
    assert_equal 'Test Championship Y', assigns(:championship).title
  end

  test "destroy action" do
    assert_difference('Championship.count', -1) do
      delete :destroy, id: Championship.last.id
    end
    assert_redirected_to championships_path
  end
end
