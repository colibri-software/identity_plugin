class TestController < ApplicationController
  def login
    render :text => do_login('/')
  end

  def logout
    do_logout('/')
  end

  def signup
    render :text => do_signup('/')
  end
end
