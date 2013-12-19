# encoding: utf-8
require "spec_helper"

describe "帮助方法测试之：" do

	describe "full_title" do
		it "应该包含标题" do
			expect(full_title("测试")).to match(/测试/)
		end

		it "应该包含网站名称" do
			expect(full_title("测试")).to match(/一个简单的微博$/)
		end

		it "首页应该不包含其它东西，包含竖线" do
			# expect(full_title("")).to match(/[^|]/)
			expect(full_title("")).not_to match(/\|/)
		end
	end

end