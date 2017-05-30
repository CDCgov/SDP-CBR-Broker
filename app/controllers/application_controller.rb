class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  def current_user
    @current_user ||= Account.first(uid: session[:user_id]) if session[:user_id]
  rescue Exception => e
    nil
  end

  def authenticate_user!
    unless current_user
      session[:redirect_url] = request.url
      redirect_to '/auth/developer'
    end
  end
end
