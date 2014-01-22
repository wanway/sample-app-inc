# encoding: utf-8
require 'spec_helper'

describe MessagesController do

	subject { page }

	describe "index" do
		let(:user) { FactoryGirl.create(:user) }
		let(:other_user) { FactoryGirl.create(:user) }

		before do
			FactoryGirl.create(:message, content: "test message one", user: user, receive_user: other_user)
			FactoryGirl.create(:message, content: "test message two", user: user, receive_user: other_user)
			sign_in other_user
			visit messages_path
		end

		describe "有合适的标题" do
			it {should have_title("所有私信列表")}
		end	

		it "有最近添加的两条私信" do
			other_user.receive_messages.each do |message|
				expect(page).to have_selector("li##{message.id}", text: "#{message.content}")
				# expect(page).to have_link("show", href: message_path)
			end
		end
	end
end
