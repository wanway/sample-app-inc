# encoding: utf-8
require 'spec_helper'

describe "静态页面测试之 -> " do

  subject {page}  

  describe "关于首页：" do
    
    before { visit root_path }

    it { should have_content('sample app') }
    it { should have_title(full_title(""))}
    it { should_not have_title('| 首页') }
    it { should have_selector('h1', :text => '首页') }

  end

  describe "关于帮忙页面：" do
    
    before { visit help_path }

    it { should have_content('help me') }
    it { should have_title('帮助') }

  end

  describe "对于关于页面：" do
    
    before { visit about_path }

    it { should have_content('about me') }
    it { should have_title('关于我们') }

  end

  describe "对于联系我们页面：" do
    
    before { visit contact_path }

    it { should have_content('联系我们') }
    it { should have_title("联系我们") }

  end

end
