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

    	it { should have_title("登陆") }
    	it { should have_selector('div.alert.alert-error', text: '用户名或者密码错误!') }

        describe "当点击其它页面时" do
            before { click_link "首页" }
            it { should_not have_selector('div.alert.alert-error') }
        end
    end

    describe "用合法的信息登陆" do
    	let(:user) { FactoryGirl.create(:user) }
    	
    	# before do
    	#	fill_in "Email", with: user.email.upcase
    	#	fill_in "Password", with: user.password
    	#	click_button "登陆"
    	# end
        before { sign_in user }

    	it { should have_title(user.name) }
    	it { should have_link('用户列表', href: users_path) }
        it { should have_link('个人资料', href: user_path(user)) }
        it { should have_link('设置', href: edit_user_path(user)) }
    	it { should have_link('登出', href: signout_path) }
    	it { should_not have_link('登陆', href: signin_path) }

        # 这个有问题，是合理的，原因是，当用户建立的时候，会出现。但建立之后，再测试就不成功了。
        # 或许有其它答案，请查看源文件，因为这个 find_by 还没有明白意思。
        # describe "保存用户之后" do
        #    before { click_button "建立用户" }
        #    let(:user) { User.find_by(email: 'wanway0311@gmail.com') }

        #    it { should have_link('登出') }
        #    it { should have_title(user.name) }
        #    it { should have_selector('div.alert.alert-success', text: 'welcome all of you') }
        # end

        describe "点登出按钮后" do
            before { click_link "登出" }
            it { should have_link("登陆") }
        end
    end

    describe "权限测试" do
        
        describe "未登陆用户" do
            let(:user) { FactoryGirl.create(:user) }

            describe "在用户控制器中" do
                
                describe "访问编辑页面" do
                    
                    before { visit edit_user_path(user) }
                    it { should have_title('登陆') }
                end

                describe "提交到更新页面" do
                    
                    before { patch user_path(user) }
                    specify { expect(response).to redirect_to(signin_path) }
                end

                describe "访问用户列表页" do
                    before { visit users_path }
                    it { should have_title("登陆") }
                end
            end

            describe "如果访问了一个受保护的页面" do
                
                before do
                    visit edit_user_path(user)
                    fill_in "Email", with: user.email
                    fill_in "Password", with: user.password
                    click_button "登陆"
                end

                describe "当登陆后" do
                    it "should 重新跳转回原来的页面" do
                        expect(page).to have_title("修改用户")
                    end
                end
            end
        end

        describe "错误的用户" do
           
           let(:user) { FactoryGirl.create(:user) }
           let(:wrong_user) { FactoryGirl.create(:user, email: "wangweiwei@tuan800.com") }

           before { sign_in user, no_capybara: true }

           describe "提交一个 get 请求到编辑页面" do
               
               before { get edit_user_path(wrong_user) }

               specify { expect(response.body).not_to match(full_title("修改用户")) }
               specify { expect(response).to redirect_to(root_url) }
           end

           describe "提交一个 PATCH 请求到更新页面" do
               
               before { patch user_path(wrong_user) }

               specify { expect(response).to redirect_to(root_url) }
           end

        end

        describe "非管理员用户" do
            let(:user) { FactoryGirl.create(:user) }
            let(:non_admin) { FactoryGirl.create(:user) }

            before { sign_in non_admin, no_capybara: ture }

            describe "发送一个 DELETE 请求到 Users#destory action" do
                before { delete user_path(user) }
                specify { expect(response).to redirect_to(root_path) }
            end
        end
    end
    
  end
end
