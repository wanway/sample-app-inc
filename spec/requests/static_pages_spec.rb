# encoding: utf-8
require 'spec_helper'

describe "静态页面测试之" do
  
  describe "关于首页：" do
    
    it "页面中必须包含 'sample app'" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      # get static_pages_index_path
      visit '/static_pages/home'
      # response.status.should be(200)
      expect(page).to have_content('sample app')
    end

    it "标题中必须包含 Welcome all of you" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      # get static_pages_index_path
      visit '/static_pages/home'
      # response.status.should be(200)
      expect(page).to have_title("Welcome all of you")
    end

    it "标题中必须不包含'首页'字样" do
      visit '/static_pages/home'
      expect(page).not_to have_title('| 首页')
    end

    it "h1标签中必须包含'首页'" do
    	visit '/static_pages/home'
    	page.should have_selector('h1', :text => '首页')
    end

  end

  describe "关于帮忙页面：" do
    
    it "页面中必须包含'help me'" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      # get static_pages_index_path
      visit '/static_pages/help'
      # response.status.should be(200)
      expect(page).to have_content('help me')
    end

	it "标题中必须包含'帮助'" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      # get static_pages_index_path
      visit '/static_pages/help'
      # response.status.should be(200)
      expect(page).to have_title('帮助')
    end

  end

   describe "对于关于页面：" do
    
    it "页面中必须包含'about me'" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      # get static_pages_index_path
      visit '/static_pages/about'
      # response.status.should be(200)
      expect(page).to have_content('about me')
    end

    it "标题中必须包含'关于我们'" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      # get static_pages_index_path
      visit '/static_pages/about'
      # response.status.should be(200)
      expect(page).to have_title('关于我们')
    end
  end

end
