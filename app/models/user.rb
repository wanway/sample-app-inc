class User < ActiveRecord::Base
	# has_many :messages
	has_many :send_messages, foreign_key: "user_id", class_name: "Message"
	has_many :receive_messages, foreign_key: "receive_user_id", class_name: "Message"
  has_many :microposts, dependent: :destroy
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed

	has_many :reverse_relationships, foreign_key: "followed_id",
									 class_name: "Relationship",
									 dependent: :destroy
	has_many :followers, through: :reverse_relationships, source: :follower

	# before_save { self.email = email.downcase }
	before_save { email.downcase! }
	before_create :create_remember_token # do not user {}

	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, 
					  format: { with: VALID_EMAIL_REGEX }, 
					  uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, length: { minimum: 6 }

	def User.new_remember_token
    	SecureRandom.urlsafe_base64
  	end

  	def User.encrypt(token)
    	Digest::SHA1.hexdigest(token.to_s)
  	end

  	def feed
  		# Micropost.where("user_id = ?", id)
      Micropost.from_users_followed_by(self)
  	end

      # 调用，方式同上
    def microposts_all
      Micropost.including_replies(self)
    end

    # 通过解析出 message 中的 content 中的内容来找出用户
    def self.find_user_from_message_content(content)
      content =~ /^d (\S+) (\S+)/
      User.find_by(name: $1)
    end

    def self.from_users_followed_by(user)
      followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
      where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user)
    end

  	def following?(other_user)
  		relationships.find_by(followed_id: other_user.id)
  	end

  	def follow!(other_user)
  		relationships.create!(followed_id: other_user.id)
  	end

  	def unfollow!(other_user)
  		relationships.find_by(followed_id: other_user.id).destroy
  	end

  	private

    	def create_remember_token
      		self.remember_token = User.encrypt(User.new_remember_token)
    	end
end
