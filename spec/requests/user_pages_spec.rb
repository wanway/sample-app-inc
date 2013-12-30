# encoding: utf-8
require 'spec_helper'

describe "用户页面测试之：" do
  
  subject {page} 

  describe "关于 首页" do
    
    let(:user) { FactoryGirl.create(:user) }
    # sign_in FactoryGirl.create(:user)
    # FactoryGirl.create(:user, name: "Bob", email: "bob@gmail.com")
    # FactoryGirl.create(:user, name: "Ben", email: "ben@gmail.com")
    before(:each) do
      sign_in user
      visit users_path
    end
    
    it { should have_title("用户列表") }
    it { should have_selector("h1", text: "用户列表") }

    # it "should 有所有用户" do      
    #  User.all.each do |user|
    #    expect(page).to have_selector('li', text: user.name)
    #  end      
    # end

    describe "分页" do

      before(:all) { 30.times {FactoryGirl.create(:user)} }
      after(:all) {User.delete_all}

      it { should have_selector('div.pagination') }

      it "应该包含所有的用户" do

        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text:user.name)
        end
      end
    end

  end

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

  describe "关于 修改用户 页面" do
    
    let(:user) { FactoryGirl.create(:user) }

    # before { visit edit_user_path(user) }
    # 直接用上面一行，会出现 Capybara::ElementNotFound: 的错误
    # 原因是未登陆，直接访问修改页面，会被跳转
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "页面检查" do
      it { should have_title("修改用户") }
      it { should have_link('修改'), href: 'http://gravatar.com/emails' }
      it { should have_content("更新个人信息") }
    end

    describe "用正确的信息" do
      let(:new_name) { "new name" }
      let(:new_email) { "new@example.com" }

      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "once again", with: user.password
        click_button "修改"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('登出', href: signout_path)}
      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end
    
  end
end
