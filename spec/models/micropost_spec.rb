# encoding: utf-8
require 'spec_helper'

describe Micropost do
  
  let(:user) { FactoryGirl.create(:user) }
  before {@micropost = user.microposts.build(content: "the first content")}

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "如果用户ID不存在" do
  	before { @micropost.user_id = nil }
  	it { should_not be_valid }
  end

  describe "内容不能为空" do
  	before { @micropost.content = "" }
  	it { should_not be_valid }
  end

  describe "内容不能太长，只能有140个" do
  	before { @micropost.content = "a" * 141 }
  	it { should_not be_valid }
  end
end
