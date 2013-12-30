FactoryGirl.define do
	factory :user do
		sequence(:name) {|n| "Exam #{n}"}
		sequence(:email) {|n| "test_#{n}@gmail.com"}
		password "123456"
		password_confirmation "123456"
	end
end