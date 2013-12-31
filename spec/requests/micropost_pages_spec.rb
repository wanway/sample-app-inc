# encoding: utf-8
require 'spec_helper'

describe "MicropostPages" do

	subject { page }

	let(:user){ FactoryGirl.create(:user) }
	before { sign_in user }

	describe "发送微博" do

		before { visit root_path }

		describe "用不合法的信息" do

			it "不能创建微博" do
				expect { click_button "发送" }.not_to change(Micropost, :count)
			end

			describe "错误提示" do

				before { click_button "发送" }
				it {should have_content('错误')}
			end
		end

		describe "用合法的信息" do

			before { fill_in 'micropost_content', with: 'the test content'}

			# it "可以发送微博" do
			#	expect{ click_button "发送" }.to change(Micropost, :count).by(1)
			# end
		end
	end

	describe "删除微博" do

		before { FactoryGirl.create(:micropost, user: user) }

		describe "用正确的用户" do

			before { visit root_path }
			
			it "可以删除掉一个微博" do
				expect { click_link "删除" }.to change(Micropost, :count).by(-1)
			end

		end

	end
end
