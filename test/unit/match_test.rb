require 'test_helper'

class MatchTest < ActiveSupport::TestCase
  def setup
    Node.rebuild!
  end

  test "players" do
    match = matches(:quarterfinal_1)
    # 1st round match (match, that is)
    assert_equal 0, (match.players - [players(:player_1), players(:player_2)]).length, "Direct players don't match"

    # 2nd round match
    player1 = players(:player_1)
    match.update_attribute(:winner, player1)
    match2 = match.parent
    assert_equal 0, (match2.players - [player1]).compact.length, "Indirect players don't match"
  end

  test "winner propagation" do
    match = matches(:quarterfinal_2)
    player1, player2 = match.players
    match.update_attribute(:winner, player1)
    assert_equal player1, match.winner, "Winner is not set"

    # test propagation
    match2 = match.parent
    match2.update_attribute(:winner, player1)
    assert_equal player1, match2.winner
    match.update_attribute(:winner, player2)
    assert_equal player2, match.winner
    assert_nil match2.winner, "Not propagated"
  end

  test "match play statuses" do
    assert matches(:quarterfinal_1).played?
    assert !matches(:quarterfinal_2).played?
    assert !matches(:semifinal_1).played?
  end

  test "match relevance" do
    assert matches(:semifinal_1).relevant?
    assert matches(:final).relevant?
    assert matches(:quarterfinal_3).relevant?
    assert !matches(:quarterfinal_4).relevant?
  end

  test "if match needs playing" do
    assert matches(:quarterfinal_2).needs_playing?
    assert !matches(:quarterfinal_3).needs_playing?
    assert !matches(:quarterfinal_4).needs_playing?
    assert matches(:final).needs_playing?
  end

  test "impicit and explicit winners" do
    assert !matches(:quarterfinal_2).has_implicit_winner?
    assert matches(:quarterfinal_3).has_implicit_winner?
    assert_equal players(:player_5), matches(:quarterfinal_3).implicit_winner
    assert !matches(:quarterfinal_4).has_implicit_winner?

    assert matches(:quarterfinal_2).needs_explicit_winner?
    assert !matches(:quarterfinal_3).needs_explicit_winner?
    assert !matches(:quarterfinal_4).needs_explicit_winner?

    assert_equal matches(:semifinal_1).winner, matches(:semifinal_1).explicit_or_implicit_winner
    assert_equal matches(:quarterfinal_3).implicit_winner, matches(:quarterfinal_3).explicit_or_implicit_winner
    assert_nil matches(:final).explicit_or_implicit_winner
  end
end
