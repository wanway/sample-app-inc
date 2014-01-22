FactoryGirl.define do
	factory :user do
		sequence(:name) {|n| "Exam #{n}"}
		sequence(:email) {|n| "test_#{n}@gmail.com"}
		password "123456"
		password_confirmation "123456"

		factory :admin do
			admin true
		end
	end

	factory :micropost do
		content "test content"
		user
	end

	factory :message do
		content "test message"
		user
		receive_user "user"
	end
end
