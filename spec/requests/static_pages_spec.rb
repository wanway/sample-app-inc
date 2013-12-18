# encoding: utf-8
require 'spec_helper'

describe "静态页面测试之 -> " do

  subject {page}  

  describe "关于首页：" do
    
    before { visit root_path }

    it { should have_content('首页') }
    it { should have_title(full_title(""))}
    it { should_not have_title('| 首页') }
    it { should have_selector('h1', text: '首页') }

  end

  describe "关于 获得帮助 页面：" do
    
    before { visit help_path }

    it { should have_selector('h1', text: '获得帮助') }
    it { should have_title('获得帮助') }

  end

  describe "对于 关于我们 页面：" do
    
    before { visit about_path }

    it { should have_selector('h1', text: '关于我们') }
    it { should have_title('关于我们') }

  end

  describe "对于 联系作者 页面：" do
    
    before { visit contact_path }

    it { should have_selector('h1', text: '联系作者') }
    it { should have_title("联系作者") }

  end

end
