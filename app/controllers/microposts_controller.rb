# encoding: utf-8
class MicropostsController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy]
	before_action :correct_user, only: [:destroy]

	def create
		@micropost = current_user.microposts.build(micropost_params)

		respond_to do |format|

			if @micropost.save
				flash[:success] = "微博发送成功"
				format.html { redirect_to root_url, :layout => !request.xhr? }
				format.js { render :status => :created, :location => @micropost, :layout => !request.xhr? }
			else
				@feed_items = []
				flash[:error] = "微博内容不能为空"
				format.html { redirect_to root_url, :layout => !request.xhr? }
				format.js { render :status => :unprocessable_entity }
			end
		end
	end

	def destroy
		@micropost.destroy
		redirect_to root_url
	end

	def show
		@micropost = Micropost.find(params[:id])
		@reply = @micropost.replies.build
		respond_to do |format|
			format.js
		end
	end

	private

		def micropost_params
			params.require(:micropost).permit(:content, :in_reply_to, :user_id)
		end

		def correct_user
			@micropost = current_user.microposts.find_by(id: params[:id])
			redirect_to root_url if @micropost.nil?
		end
end