# encoding: utf-8
class MessagesController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy]

	def create
		
		# 从表单提交过来的私信中，包含有[ d 用户名 内容 ]，
		# 而私信的字段是 id、content、user_id（发送者的ID）、receive_user_id（接收者的ID）
		# 所以，我需要从提交过来的混合体中分享出内容和接收者

		# 这个的作用是，找到接收者
		# 虽然能大体达到效果，
		# 		但后面的 Message.new(content: message_params) 是为了构建一个 message 对象而为，没有实际作用
		# 		需要改正
		@receive_user = User.find_user_from_message_content(Message.new(content: message_params)
		
		# 这个的作用是，找到内容
		# 虽然能达到效果，
		#		但这貌似不是对象的写法，需要改正，这个方法定义在 messages_helper.rb 中
		@content = find_content_from(message_params)

		# 准备完毕，建立一条私信
		@message = current_user.messages.build(content: @content, receive_user_id: @receive_user.id)

		respond_to do |format|
			if @message.save
				format.html { redirect_to root_url, :layout => !request.xhr? }
			else
				@feed_items = []
				format.html { render 'static_pages/home', :layout => !request.xhr? }
			end
		end
	end

	private

		def message_params
			params.require(:message).permit(:content)
		end
end

# 我的问题是

# 1、刚才从表单过来的值，我用 User.find_user_from_message_content 是不是有问题啊，怎么样写，会比较正确。

# 2、刚才从表单过来的值，我用 find_content_from(message_params) 这个 help 方法，是不是也是错的，正确的思路是怎么样的


