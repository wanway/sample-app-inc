# encoding: utf-8
require 'spec_helper'

describe "用户页面测试之：" do
  
  subject {page} 

  describe "关于 新用户注册 页面" do
    
    before { visit signup_path }

    it { should have_title("新用户注册") }
    it { should have_selector("h1", text: "新用户注册") }

  end

  describe "关于 用户显示 页面" do
  	
  	let(:user) { FactoryGirl.create(:user) }
  	
  	before { visit user_path(user) }

	it { should have_title(user.name) }

	it { should have_selector("h1", text: user.name) }

  end
end
