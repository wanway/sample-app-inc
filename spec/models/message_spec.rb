# encoding: utf-8

require 'spec_helper'

describe Message do
	
	let(:user) { FactoryGirl.create(:user) }
	let(:receive_user) { FactoryGirl.create(:user) }

	before { @message = user.messages.build(content: "message", receive_user_id: receive_user.id) }

	subject { @message }

	it { should be_valid }

	describe "字段必须存在" do
		it { should respond_to(:content) }
		it { should respond_to(:user_id) }
		it { should respond_to(:receive_user_id) }
		its(:user) { should eq user }
		its(:receive_user) { should eq receive_user }
	end

	describe "内容不能为空" do
		before { @message.content = nil }
		it { should_not be_valid }
	end

	describe "内容不能超过140个字" do
		before { @message.content = "a" * 141 }
		it { should_not be_valid }
	end
	
	describe "私信的发送者为空" do
		before { @message.user_id = nil }
		it { should_not be_valid }
	end

	describe "私信的接收者为空" do
		before { @message.receive_user_id = nil }
		it { should_not be_valid }
	end
end