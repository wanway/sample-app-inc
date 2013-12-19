# encoding: utf-8
require 'spec_helper'

describe User do
  
  before { @user = User.new(name: "wanway",
                            email: "wanway0311@gmail.com",
                            password: "passwo",
                            password_confirmation: "passwo") }
  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to :email }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }
  it { should respond_to :password_digest }
  it { should respond_to :authenticate }
  it { should be_valid }

  describe "如果名字为空，则不能通过" do  	
  	before { @user.name = "" }
  	it { should_not be_valid }
  end
  
  describe "如果邮箱地址为空，则不能通过" do
  	before { @user.email = "" }
  	it { should_not be_valid }
  end

  describe "如果名字太长，则不能通过，最多 50 个字符" do
  	before { @user.name = "w" * 51 }
  	it { should_not be_valid }
  end

  describe "邮箱格式不对的时候" do
  	
  	it "不能通过" do
  		addresses = %w[wanway0311@g_mail.com wanway0311@gmailcom wanway0311@@gmail.com]
  		addresses.each do |address|
  			@user.email = address
  			expect(@user).not_to be_valid
  		end
  	end

  end

  describe "邮箱格式对的时候" do

  	it "可以通过" do

  		addresses = %w[wanway0311@gmail.com wangweiwei@TUAN800.com wei.wang@tuan800.com]

		  addresses.each do |address|
			@user.email = address
			expect(@user).to be_valid
      end

  	end
  	
  end

  describe "当有相同的邮箱地址是" do

    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
    
  end

  describe "当密码为空是" do
    
    before do
      @user = User.new(name:"wanway",
                       email:"wanway0311@gmail.com", 
                       password:"", 
                       password_confirmation:"")
    end

    it {should_not be_valid}
  end

  describe "当确认密码不匹配时" do
    before {@user.password_confirmation = "errpassword"}
    it {should_not be_valid}
  end

  describe "测试密码是否正确" do
    before {@user.save}
    let(:found_user) { User.find_by(email: @user.email) }

    describe "如果密码正确" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "如果密码不正确" do
      let(:user_for_invalid_password) { found_user.authenticate("err") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  describe "密码太短时" do
    before { @user.password = @user.password_confirmation = "w" * 5 }
    it { should be_valid }
  end

end