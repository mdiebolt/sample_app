require 'spec_helper'

describe "Users" do
  describe "signup" do
    describe "failure" do

      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => ""
          fill_in "Email",        :with => ""
          fill_in "Password",     :with => ""
          fill_in "Confirmation", :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end

      it "should clear both password fields" do
        visit signup_path
        fill_in "Name",         :with => ""
        fill_in "Email",        :with => ""
        fill_in "Password",     :with => "bad"
        fill_in "Confirmation", :with => "pass"
        click_button
        response.should have_selector("input[name='user[password]'][value='']")
        response.should have_selector("input[name='user[password_confirmation]'][value='']")
      end
    end

    describe "success" do

      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => "Matt Diebolt"
          fill_in "Email",        :with => "mdiebolt@example.com"
          fill_in "Password",     :with => "foobar"
          fill_in "Confirmation", :with => "foobar"
          click_button
          response.should have_selector("div.flash.success", :content => "Welcome")
          response.should render_template('users/show')
        end.should change(User, :count).by 1
      end
    end
  end

  describe "sign in/out" do

    describe "failure" do
      it "should not sign a user in" do
        integration_sign_in(User.new(:email => "", :password => ""))
        response.should have_selector("div.flash.error", :content => "Invalid")
      end
    end

    describe "success" do
      it "should sign a user in and out" do
        user = Factory :user
        integration_sign_in user
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end

      it "should display correctly pluralized micropost count" do
        user = Factory :user_with_microposts
        integration_sign_in user
        controller.should be_signed_in
        response.should have_selector("strong", :content => "#{user.microposts.count} microposts")
      end

      it "should not display delete links for microposts a user did not create" do
        user = Factory :user
        user2 = Factory(:user, :email => Factory.next(:email))
        integration_sign_in user
        controller.should be_signed_in
        visit '/users/2'
        response.should_not have_selector("a", :content => "delete")
      end
    end
  end
end
