# encoding: utf-8
require 'spec_helper'

describe "静态页面测试之 -> " do

  subject {page} 

  shared_examples_for "all static pages"  do
    it { should have_title( full_title(page_title) ) }
    it { should have_selector("h1", text: page_title) }
  end

  describe "关于首页：" do
    
    before { visit root_path }

    let (:page_title) { "" }
    # let (:h1_content) { "首页" }

    it_should_behave_like "all static pages"

    it { should_not have_title('| 首页') }

    describe "登陆用户" do

      let(:user) { FactoryGirl.create(:user) }

      before do
        FactoryGirl.create(:micropost, user: user, content: "First")
        FactoryGirl.create(:micropost, user: user, content: "Second")
        sign_in user
        visit root_path
      end

      it "会更新到首页" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "关注与粉丝数量" do

        let(:other_user) { FactoryGirl.create(:user) }

        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("关注 0", href: following_user_path(user)) }
        it { should have_link("粉丝 1", href: follower_user_path(user)) }

      end
      
    end

  end

  describe "关于 获得帮助 页面：" do
    
    before { visit help_path }

    let (:page_title) { "获得帮助" }
    # let (:h1_content) { "获得帮助" }

    it_should_behave_like "all static pages"

  end

  describe "对于 关于我们 页面：" do
    
    before { visit about_path }

    let (:page_title) { "关于我们" }
    # let (:h1_content) { "关于我们" }

    it_should_behave_like "all static pages"
    
  end

  describe "对于 联系作者 页面：" do
    
    before { visit contact_path }

    let (:page_title) { "联系作者" }
    # let (:h1_content) { "联系作者" }

    it_should_behave_like "all static pages"

  end

  it "应该有正确的链接" do
    
    visit root_path

    click_link "首页"
    expect(page).to have_title(full_title(""))

    click_link "帮助"
    expect(page).to have_title(full_title("帮助"))

    click_link "关于"
    expect(page).to have_title(full_title("关于我们"))

    click_link "联系"
    expect(page).to have_title(full_title("联系作者"))

    click_link "注册"
    expect(page).to have_title(full_title("新用户注册"))

    click_link "一个简单的微博"
    expect(page).to have_title(full_title(""))

    click_link "Sign up now!"
    expect(page).to have_title(full_title("新用户注册"))

  end

end
