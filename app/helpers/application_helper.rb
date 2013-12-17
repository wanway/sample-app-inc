module ApplicationHelper

	# 对每个页面，返回一个完整的标题。
	def full_title(page_title)
		base_title = "Welcome all of you"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end
end
