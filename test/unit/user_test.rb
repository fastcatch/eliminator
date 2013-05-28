require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "create guest user" do
    user = User.new_guest
    assert user.valid?
    assert user.guest?
  end

  test "move associations" do
    user = User.new_guest
    user.save
    mrx = users(:MrX)
    ids = mrx.championships.pluck(:id).sort
    assert ids.size > 0

    mrx.move_associations_to user
    assert_equal 0, mrx.championships.count
    assert_equal ids, user.championships.pluck(:id).sort
  end

end
