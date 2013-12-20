# encoding: utf-8
require 'spec_helper'

describe "AuthenticationPages" do
  
  subject { page }

  describe "登陆页面" do
    
    before { visit signin_path }

    it { should have_title("登陆") }
    it { should have_selector("h1", "登陆") }

    describe "用错误的信息登陆" do
    	before { click_button "登陆" }

    	it { should have_title("注册") }
    	it { should have_selector('div.alert.alert-error', text: 'Invalid') }
    end

    describe "用合法的信息登陆" do
    	let(:user) { FactoryGirl.create(:user) }
    	
    	before do
    		fill_in "Email", with: user.email.upcase
    		fill_in "Password", with: user.password
    		click_button "登陆"
    	end

    	it { should have_title(user.name) }
    	it { should have_link('用户资料', href: user_path(user)) }
    	it { should have_link('注册', href: signout_path) }
    	it { should_not have_link('登陆', href: signin_path) }
    end
    
  end
end
