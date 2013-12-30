# encoding: utf-8
namespace :db do
	
	desc "填充一些用户数据到用户表"
	task populate: :environment do
		User.create!(name: "wanway", 
					 email: "wanway0311@gmail.com", 
					 password: "123456", 
					 password_confirmation: "123456")

		99.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@gmail.com"
			password = "password"
			User.create!(name: name, 
						 email: email,
						 password: password,
						 password_confirmation: password)
		end
	end
end