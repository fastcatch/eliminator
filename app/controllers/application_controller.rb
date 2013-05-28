class ApplicationController < ActionController::Base
  protect_from_forgery

protected

  # if user is logged in, return devise's current_user, else return guest_user
  # current_user is overwritten so let's save it first
  alias_method :non_guest_current_user, :current_user
  def current_user
    if non_guest_current_user
      if session[:guest_user_id]
        logging_in
        session[:guest_user_id] = nil
      end
      non_guest_current_user
    else
      identification_required? ? guest_user : nil
    end
  end
  helper_method :current_user

  def compile_attrs_from_xeditable(hash)
    {hash['name'] => hash['value']}
  end

private

  # true if identification (guest at least)
  # is required to access the controller#action
  def identification_required?
    !(controller_name == "championships"  &&  action_name == "show")
  end

  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_user
    begin
      if !@cached_guest_user
        session[:guest_user_id] ||= create_guest_user.id
        @cached_guest_user = User.find(session[:guest_user_id])
      end
    rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
      session[:guest_user_id] = nil
      @cached_guest_user = nil
      guest_user
    end
    @cached_guest_user
  end

  # called (once) when the user logs in
  def logging_in
    # copy the guest user's championships into the new one (merge them in...)
    guest_user.move_associations_to non_guest_current_user

    # remove guest user
    # (not absolutely neccesary as the creation of new ones would eventually remove it)
    guest_user.destroy
  end

  def create_guest_user
    u = User.new_guest
    #u.save!(:validate => false)
    u.save
    session[:guest_user_id] = u.id
    @new_guest_user_created = true
    u
  end

end
