class Micropost < ActiveRecord::Base
	# has_many :reply, foreign_key: "in_reply_to", source: :micropost
	belongs_to :user
	has_many :replies, class_name: "Micropost", foreign_key: "in_reply_to"
	belongs_to :micropost, class_name: "Micropost", foreign_key: "in_reply_to"
	default_scope -> { order('created_at DESC') }
	validates :content, presence: true, length: { maximum: 140 }
	validates :user_id, presence: true

	def self.from_users_followed_by(user)
		followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
		where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user)
	end

	# 类方法
	def self.including_replies(user)
		where("user_id = ? and in_reply_to is null", user.id)
	end
end