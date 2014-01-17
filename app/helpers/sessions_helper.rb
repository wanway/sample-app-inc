# encoding: utf-8
module SessionsHelper
	
	# 登陆用户：生成随机数、将这个随机数加到 cookie、将这个随机数加密后存到数据库、将登陆用户设置为当前用户
	def sign_in(user)
		remember_token = User.new_remember_token
		cookies.permanent[:remember_token] = remember_token
		user.update_attribute(:remember_token, User.encrypt(remember_token))
		self.current_user = user
	end

	# 是否登陆：实际上就是判断当前用户是否存在，不需要参数
	def signed_in?
		!current_user.nil?
	end

	# 设置登陆的用户
	def current_user=(user)
		@current_user = user
	end

	# 将 cookie 取出来进行加密、从数据库查询是否有，如果没有，就为空
	def current_user
		remember_token = User.encrypt(cookies[:remember_token])
		@current_user ||= User.find_by(remember_token: remember_token)
	end

	# 当前用户是否已经登陆
	def current_user?(user)
		user == current_user
	end

	# 登陆
	def signed_in_user
      unless signed_in?
      	store_location
      	redirect_to signin_url, notice: "请登陆"
      end
    end

	# 登陆：删除 cookie、删除当前用户
	def sign_out
		cookies.delete(:remember_token)
		#current_user.update_attribute(:remember_token, User.encrypt(User.new_remember_token))
		self.current_user = nil
	end

	# 如果有给返回地址，就去返回地址，如果没有，就到默认的
	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end

	# 储存当前路径，如果存在的话
	def store_location
		session[:return_to] = request.fullpath if request.get?
	end
end
