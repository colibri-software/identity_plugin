class TestController < ApplicationController
  def login
    render :text => do_login('/', self)
  end

  def logout
    do_logout('/', self)
  end

  def signup
    render :text => do_signup('/', self)
  end
end
