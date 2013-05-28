#
# N.B. championship elimination trees are created at the same time the championship itself
#      and destroyed automatically
#
#      You are *NOT* supposed to add or remove nodes in any other way.  You have been warned.
#

#
# Node content is polymorphic (Player or Match)
#
class Node < ActiveRecord::Base
  acts_as_nested_set

  belongs_to :championship
  validates_presence_of :championship

  attr_accessible :parent_id, :content
  belongs_to :content, polymorphic: true
end
