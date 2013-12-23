# encoding: utf-8
class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			# 在 sessions_helper.rb 中有定义
			sign_in user
			redirect_to user
		else
			flash.now[:error] = '用户名或者密码错误!'
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_path
	end
end
