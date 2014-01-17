# encoding: utf-8
class MessagesController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy]

	def create
		
		# 从提交过来的数据中，找出收件人
		@receive_user = User.find_user_from_message_content(message_params[:content])
		
		# 从提交过来的数据中，找出真正的内容
		#（疑问：这个方法很奇怪，因为并没有查询数据库，是否可以写成一般方法，需要如何写呢）
		@content = Message.find_contet_from_message_content(message_params[:content])

		# 建立一条完整的私信，出错：undefined method `id' for nil:NilClass
		@message = current_user.messages.build(content: @content, receive_user_id: @receive_user.id) if !@receive_user.nil?

		respond_to do |format|
			if !@message.nil? && @message.save
				flash[:alert] = "私信发送成功"
				format.html { redirect_to root_url, :layout => !request.xhr? }
			else
				@message = []
				flash[:error] = "你没有关注该用户或者该用户不存在"
				format.html { redirect_to root_url }
			end
		end
	end

	private

		def message_params
			params.require(:message).permit(:content)
		end
end