require 'test_helper'

class ChampionshipTest < ActiveSupport::TestCase
  def setup
    Node.rebuild!
  end

  test "create" do
    championship = users(:MrX).championships.build(number_of_players: 3, title: 'Unit Test')
    assert_kind_of Championship, championship, "Championship not initialized"
    assert championship.valid?
    championship.save
    assert_equal 4, championship.number_of_players, "Improper rounding of number of players"
    assert_equal 4, championship.players.count, "Improper number of players created"
    assert_equal 3, championship.matches.count, "Improper number of matches created"
    assert_equal (3+4), championship.nodes.count, "Improper number of nodes created"

    assert_kind_of Node, championship.board, "Board is an improper reference"
  end

  test "simple functions" do
    championship = championships(:tournament)
    assert_equal 3, championship.number_of_rounds, "Improper number of rounds"
  end

end
