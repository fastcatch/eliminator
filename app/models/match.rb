class Match < ActiveRecord::Base
  belongs_to :championship
  validates_presence_of :championship_id

  has_one :node, class_name: '::Node', as: :content, inverse_of: :content
  belongs_to :winner, class_name: "Player", foreign_key: :winner_id

  attr_accessible :location, :result, :start_time, :winner, :winner_id

  before_validation Proc.new{|match| match.result = nil if match.winner.blank?}
  validates_each :winner do |record, attr, value|
    record.errors.add attr, :invalid if value.present? && !record.players.include?(value)
  end

  after_save :propagate_changes

  # get parent content (Match or nil)
  def parent
    self.node && self.node.parent && self.node.parent.content
  end

  # get the content of children (Match or Player)
  def children
    self.node.children.collect(&:content)
  end

  def players
    children.collect{|child| player_of child}
  end

  # has it been played?
  def played?
    winner.present?
  end

  # are there any players in the subtree at all?
  def relevant?
    existing_subtree_players.size > 0
  end

  # needs playing or outcome can be determined automatically
  def needs_playing?
    # if either both children are matches and they both need relevant
    # OR
    # both children are players and both are present
    children.count {|child| child.is_a?(Match) ? child.relevant? : child.present?} == 2
  end

  # has exactly one "relevant" branch
  def has_implicit_winner?
    !needs_playing? && children.count {|child| child.explicit_or_implicit_winner.present?} == 1
  end

  # are both branches relevant?
  def needs_explicit_winner?
    needs_playing? && children.count {|child| child.explicit_or_implicit_winner.present?} == 2
  end

  # if it has only one relevant branch fetch the winner from that one
  def implicit_winner
    # if only player is present in our subtree that player is the implicit winner
    children.detect {|child| child.explicit_or_implicit_winner.present?}.explicit_or_implicit_winner if has_implicit_winner?
  end

  def explicit_or_implicit_winner
    implicit_winner || winner
  end

  def reset_results
    update_attributes result: nil, winner: nil
  end

private
  def player_of(entity)
    entity.is_a?(Player) ? entity : entity.try(:winner)
  end

  # if winner changed let my parent know about it (reset results)
  # (which in turn will propagate it on so that it gets propagated up to the root)
  def propagate_changes
    if !(changed_attributes.keys & %w(winner winner_id)).empty?
      parent.reset_results if parent.present?
      self.reload
    end
  end

  def existing_subtree_players
    self.node.leaves.collect{|l| l.content if l.content.present?}.compact
  end
end
