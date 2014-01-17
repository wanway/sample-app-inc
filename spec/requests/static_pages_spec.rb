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
        it { should have_link("粉丝 1", href: followers_user_path(user)) }

      end

      describe "关于首页的发送框" do

        describe "微博发送框" do

          # 以下均可用，但太繁琐

          # it "初始状态，有微博发送框" do
          #  page.should have_xpath('//*[form[@id="new_micropost"] and form[@style="display:block"]]')
          # end

          # it "初始状态，微博的按钮可见" do
          #  page.should have_xpath('//*[form[@id="new_micropost"] and form[@style="display:block"]]//input[@id="micropost_commit"]')
          # end

          # it "初始状态，微博按钮的文字是，发送" do
          #  find("#new_micropost").should have_button("发送")
          # end

          describe "原始状态" do

            it "有微博发送框" do
              page.should have_xpath('//*[@id="new_micropost"]')
            end

            it "微博发送按钮正确" do
              find("#new_micropost").should have_button("发送")
            end

          end

          describe "满足规则，而且内容是对的" do

            before do
              within("#new_micropost") do
                fill_in "micropost_content", :with => "d #{user.name} 测试内容"
              end

              # find("#micropost_content").send_keys "foo"
              # page.evaluate_script("document.forms[0].textarea[0].click()")
              # element.send_keys "foo"
            end

            it "应该没有发送按钮" do
              page.should_not have_button("发送")
            end

            it "应该有发私信按钮" do
              page.should have_button("发私信")
            end

            # it "没有微博发送框" do
            #  page.should have_xpath('//*[@id="new_micropost"]')
            # end

            # it "有私信发送框" do
            #  page.should have_xpath('//*[@id="new_message"]')
            # end            

          end

        end

        describe "私信发送框" do

          it "初始状态，没有私信发送框" do
            page.should_not have_xpath('//*[@id="new_message"]')
          end

        end

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

    click_link "一个简单的微博"
    expect(page).to have_title(full_title(""))

    click_link "Sign up now!"
    expect(page).to have_title(full_title("新用户注册"))

  end

end