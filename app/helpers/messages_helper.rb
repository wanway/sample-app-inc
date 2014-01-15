module MessagesHelper
	
	# 从表单发送的私信内容中，分离出真正的内容
	def find_content_from(content)
		content =~ /^d (\S+) (\S+)/
		$2
	end
end
