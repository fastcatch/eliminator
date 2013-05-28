class Player < ActiveRecord::Base
  belongs_to :championship
  validates_presence_of :championship

  has_one :node, class_name: '::Node', as: :content, inverse_of: :content

  attr_accessible :name

  after_save :propagate_changes

  # get parent (Match)
  def parent
    self.node && self.node.parent && self.node.parent.content
  end

  def winner
    self
  end
  alias_method :explicit_or_implicit_winner, :winner

  def blank?
    self.name.blank?
  end
  def present?
    !self.blank?
  end

  def to_s
    name
  end

protected
  # if player data changed let my parent know about it (reset results)
  # (which in turn will propagate it on so that it gets propagated up to the root)
  def propagate_changes
    if !(changed_attributes.keys & %w(name)).empty?
      parent.reset_results if parent.present?
    end
  end
end
