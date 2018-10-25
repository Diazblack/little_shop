class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    @user_lookup ||= User.find(sessin[:user_id])
  end 
end
