class Championship < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id

  has_many :players, dependent: :destroy
  has_many :matches, dependent: :destroy
  has_many :nodes, dependent: :destroy

  attr_accessible :title, :number_of_players

  validates_presence_of :title    # uniqueness check should take care of it but doesn't...
  validates_uniqueness_of :title, scope: :user_id
  validates_each :number_of_players do |record, attr, value|
    record.errors.add attr, :invalid unless value.is_a?(Fixnum) && value >= 2
  end

  before_validation :round_up_players!
  after_save :setup_board, on: :create

  # handle to the root of the elimniation tree
  def board
    self.nodes.where(parent_id: nil).first
  end

  def number_of_rounds
    Math.log2(number_of_players).round(0)
  end

private

  def round_up_players!
    self.number_of_players = Championship.round_up_to_the_nearest_power_of_2(self.number_of_players)
  end

  # taken from http://graphics.stanford.edu/~seander/bithacks.html#RoundUpPowerOf2
  # will only work up to 32 bits but that's way more than what we practically need here
  def self.round_up_to_the_nearest_power_of_2(num)
    if num.is_a?(Fixnum) && num>0
      num -= 1
      num |= num >> 1
      num |= num >> 2
      num |= num >> 4
      num |= num >> 8
      num |= num >> 16
      num += 1
    else
      num
    end
  end

  #
  # Initialize the board
  # the board is a complete binary tree represented as an awesome nested set of 'node's
  # leaves are players
  # other nodes (up to the root) are the matches
  #
  # This is to be run exactly once per championship
  #
  def setup_board
    create_child_nodes_of(nil, Math.log2(number_of_players))
  end

  # recursively create nodes for the whole tree
  def create_child_nodes_of(node, levels_to_go)
    if levels_to_go == 0
      # if hit bottom, create player
      this = self.nodes.create(content: self.players.create(name: ""))
      this.move_to_child_of(node)
    else
      # create match
      this = self.nodes.create(content: self.matches.create)
      this.move_to_child_of(node) if node
      # create children recursively
      create_child_nodes_of(this, levels_to_go-1)   # "upper"
      create_child_nodes_of(this, levels_to_go-1)   # "lower"
    end
    this
  end

end
