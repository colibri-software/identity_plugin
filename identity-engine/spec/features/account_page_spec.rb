require 'spec_helper'

describe "Account pages" do
  # Sign up
  describe "when the user is creating an account" do
    describe "with valid information" do
      it "should create a new user" do
        IdentityEngine::User.count.should == 0
        create_new_user('test', 'valid@example.com', 'test!password')
        IdentityEngine::User.count.should == 1
      end
    end

    describe "with invalid email" do
      it "should not create a new user" do
        IdentityEngine::User.count.should == 0
        create_new_user('test', '@invalid.com', 'test!password')
        page.should have_content('a')
        IdentityEngine::User.count.should == 0 
      end
    end

    describe "with password confirmation that doesn't match password" do
      it "should not create a new user" do
        IdentityEngine::User.count.should == 0
        visit main_app.signup_path
        fill_in 'Name',                   with: 'test'
        fill_in 'Email',                  with: 'valid@example.com'
        find(:css, "input[id$='password']").set('test!password')
        fill_in 'Password confirmation',  with: "doesn't match"
        click_button 'Register'
        IdentityEngine::User.count.should == 0
      end
    end

    describe "with empty username" do
      it "should not create a new user" do
        IdentityEngine::User.count.should == 0
        create_new_user('', 'valid@example.com', 'test!password')
        IdentityEngine::User.count.should == 0
      end
    end
  end

  # Create user / Logging out
  describe "when the user logs out" do
    it "should have content saying 'sign in'" do
      create_new_user('test', 'valid@example.com', 'test!password')
      find_link('Sign Out').click
      page.should have_content('Sign in')
    end
  end

  # Create user / log out / log in
  describe "when the user logs in" do
    it "should have content saying 'Welcome :user.name'" do
      create_new_user('test', 'valid@example.com', 'test!password')
      find_link('Sign Out').click
      visit main_app.login_path
      fill_in 'Email',    with: 'valid@example.com'
      fill_in 'Password', with: 'test!password'
      click_button('Login')
      page.should have_content('Welcome test!')
    end
  end

  # Not logged in
  describe "when the user is not logged in" do
    describe "when visting the login page" do
      it "should have an email field" do
        visit main_app.login_path
        page.should have_field("Email")
      end

      it "should have a password field" do
        visit main_app.login_path
        page.should have_field("Password")
      end

      it "should have a login button" do
        visit main_app.login_path
        page.should have_button("Login")
      end
    end

    describe "when visiting the home page" do
      it "should have content saying 'sign in'" do
        visit main_app.root_path
        page.should have_content("Sign in")
      end
    end
  end

  # helpers
  private
  def create_new_user(name, email, password)
    visit main_app.signup_path
    fill_in 'Name',                   with: name
    fill_in 'Email',                  with: email
    find(:css, "input[id$='password']").set(password)
    fill_in 'Password confirmation',  with: password
    click_button 'Register'
  end
end
