class Message < ActiveRecord::Base
	
	belongs_to :user
	belongs_to :receive_user, foreign_key: "receive_user_id", class_name: "User"

	validates :content, presence: true, length: { maximum: 140 }
	validates :user_id, presence: true
	validates :receive_user_id, presence: true
end
