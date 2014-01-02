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

    describe "删除链接" do

      it { should_not have_link('删除') }

      describe "如果是管理员" do

        let(:admin) { FactoryGirl.create(:admin) }

        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('删除', href: user_path(User.first)) }

        it "可以删除其它用户" do
          expect do
            click_link('删除', match: :first)
          end.to change(User, :count).by(-1)
        end

        it { should_not have_link('delete', href: user_path(admin)) }
        
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
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }
  	
  	before { visit user_path(user) }

	  it { should have_title(user.name) }
	  it { should have_selector("h1", text: user.name) }

    describe "微博" do
      it { should have_content( m1.content ) }
      it { should have_content( m2.content ) }
      it { should have_content( user.microposts.count ) }
    end

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

  describe "关于 关注、粉丝 页面" do

    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }

    describe "粉丝" do
      before do
        sign_in user
        visit following_user_path(user)
      end

      it { should have_title(full_title('粉丝')) }
      it { should have_selector('h3', text: "粉丝") }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    
    end

    describe "我关注的" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end

      it { should have_title(full_title('关注')) }
      it { should have_selector('h3', text: '关注') }
      it { should have_link(user.name, href: user_path(user)) }

    end

    # 这里可能有问题
    describe "关注、取消关注按钮" do

      let(:other_user) { FactoryGirl.create(:user) }
      before { sign_in user }

      describe "关注一个用户" do
        before { visit user_path(other_user) }

        it "应该增加粉丝的数量" do

          expect do
            click_button "关注"
          end.to change(user.followed_users, :count).by(1)

        end

        it "应该增加其它用户关注的人数" do

          expect do
            click_button "关注"
          end.to change(other_user.followers, :count).by(1)

        end

        describe "按钮应该有所变化" do
          before { click_button "关注" }
          it { should have_xpath("//input[@value='取沙关注']") }
        end

      end

      describe "取消关注一个用户" do

        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "应该减少一个粉丝" do
          expect do
            click_button "取消关注"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "应该减少其它用户关注数" do
          expect do
            click_button "取消关注"
          end.to change(other_user.followers, :count).by(-1)
        end

        describe "按钮应该要变换" do
          before { click_button "取消关注" }
          it { should have_xpath("//input[@value='关注']") }
        end

      end

    end
    
  end

end
