class User < ActiveRecord::Base

  has_many :championships, dependent: :destroy

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :guest

  validates_uniqueness_of :email, unless: Proc.new{|record| record.guest?}

  #
  # create a new guest account
  #
  # as there's not other means to make sure old (unused, lingering)
  # guest accounts get removed, let's do it here
  #
  def self.new_guest
    self.where(guest: true).where('updated_at < ?', 7.days.ago).destroy_all
    new {|u| u.guest = true}
  end

  #
  # move associated records (championships, etc) from self to another user
  #
  def move_associations_to(user)
    self.championships.each do |championship|
      championship.user_id = user.id
      championship.title += Time.now.to_s(:db) if !championship.valid?
      championship.save
    end
    # make sure AR recognizes that associations have been moved
    user.reload
    self.reload
  end
end
