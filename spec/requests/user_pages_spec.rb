# encoding: utf-8
require 'spec_helper'

describe "用户页面测试之：" do
  
  subject {page} 

  describe "关于 新用户注册 页面" do
    
    before { visit signup_path }

    it { should have_title("新用户注册") }
    it { should have_selector("h1", text: "新用户注册") }

  end

end
