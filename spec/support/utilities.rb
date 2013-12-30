# encoding: utf-8
include ApplicationHelper
# 对每个页面，返回一个完整的标题。
# def full_title(page_title)
#	base_title = "一个简单的微博"
#	if page_title.empty?
#		base_title
#	else
#		"#{page_title} | #{base_title}"
#	end
# end

def sign_in(user, options={})
	if options[:no_capybara]
		# 如果没有使用 Capybara,用以下登陆
		# 不过，这种方法好恐怖，因为，他跳过了所有审核。
		remember_token = User.new_remember_token
		cookies[:remember_token] = remember_token
		user.update_attribute(:remember_token, User.encrypt(remember_token))
	else
		visit signin_path
		fill_in "Email", with: user.email.upcase
    	fill_in "Password", with: user.password
    	click_button "登陆"
	end
end