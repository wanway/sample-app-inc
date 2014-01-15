class Message < ActiveRecord::Base
	
	belongs_to :user
	belongs_to :receive_user, foreign_key: "receive_user_id", class_name: "User"

	validates :content, presence: true, length: { maximum: 140 }
	validates :user_id, presence: true
	validates :receive_user_id, presence: true

	# 通过解析出 message 中的 content 中的内容来找出用户
    def self.find_contet_from_message_content(content)
      content =~ /^d (\S+) (\S+)/
      $2
    end

end
