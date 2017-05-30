class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    user = Account.first(uid: auth['uid'].to_s)

    unless user
      render status: 401, text: 'no'
      return
    end
    rurl = session[:redirect_url] || '/'
    reset_session
    session[:user_id] = user.uid
    redirect_to rurl
  end

  def destroy
    reset_session
    redirect_to root_url
  end

  def failure
    render status: 401
  end
end
