module ApplicationHelper
  def logged_in?
    session.key?(:user_id)
  end
end
