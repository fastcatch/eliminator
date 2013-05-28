require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  def setup
    Node.rebuild!
  end

  test "parent" do
    player = players(:player_1)
    assert_equal matches(:quarterfinal_1), player.parent
  end

  test "existence functions" do
    assert players(:player_1).present?
    assert !players(:player_1).blank?
    assert !players(:player_8).present?
    assert players(:player_8).blank?
  end

  test "winner" do
    assert_equal players(:player_1), players(:player_1).winner
    assert_equal players(:player_8), players(:player_8).winner
  end

  test "to_s" do
    assert_equal players(:player_1).name, players(:player_1).to_s
  end
end
