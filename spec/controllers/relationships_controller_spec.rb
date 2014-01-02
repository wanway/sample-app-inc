# encoding: utf-8

describe RelationshipsController do

	let(:user) { FactoryGirl.create(:user) }
	let(:other_user) { FactoryGirl.create(:user) }

	before { sign_in user, no_capybara: true }

	describe "利用 ajax 创建一个关系" do

		it "应该让关系数量增加1" do
			expect do
				xhr :post, :create, relationship: { followed_id: other_user.id }
			end.to change(Relationship, :count).by(1)
		end

		it "发送请求应该是成功的" do
			xhr :post, :create, relationship: { followed_id: other_user.id }
			expect(response).to be_success
		end

	end

	describe "利用 ajax 删除一个关系" do

		before { user.follow!(other_user) }
		let(:relationship) { user.relationships.find_by(followed_id: other_user) }

		it "应该会减少关系数量" do
			expect do
				xhr :delete, :destroy, id: relationship.id
			end.to change(Relationship, :count).by(-1)
		end

		it "发送请求应该是成功的" do
			xhr :delete, :destroy, id: relationship.id
			expect(response).to be_success
		end

	end
	
end