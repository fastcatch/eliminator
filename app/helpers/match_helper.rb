module MatchHelper

  # generate list of possible winners for a match (for an input field)
  def winners_collection(match)
    collection =
    if match.needs_explicit_winner?
      [ ["no winner yet", nil, true] ] +
      match.children.collect do |item|
        winner = item.explicit_or_implicit_winner
        [winner.name + " won", winner.id, match.explicit_or_implicit_winner == winner] if winner.present?
      end.compact
    elsif match.has_implicit_winner?
      winner = match.implicit_winner
      [[winner.name + " won implicitly", winner.id, true]]
    else
      []
    end
  end
end