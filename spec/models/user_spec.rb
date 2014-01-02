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
  it { should respond_to :remember_token }
  it { should respond_to :password_digest }
  it { should respond_to :authenticate }
  it { should respond_to :admin }
  it { should respond_to :microposts }
  it { should respond_to :feed }
  it { should respond_to :relationships }
  it { should respond_to :followed_users }
  it { should respond_to :reverse_relationships }
  it { should respond_to :followers }
  it { should respond_to :following? }
  it { should respond_to :follow! }
  it { should respond_to :unfollow! }
  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

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
    it { should_not be_valid }
  end

  describe "email 大小写" do
    let(:mixed_case_email) { "Wanway0311@GMAIL.COM" }

    it "必须全部以小写保存" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  
  describe "注册页面" do
    
    before { visit signup_path }

    let(:submit) { "建立用户" }

    describe "用错误的信息" do      
      # it "不能创建新用户" do
      #  expect { click_button submit }.not_to change(User, :count)
      # end
    end

    describe "用合法的信息" do
      
      before do
        fill_in "Name",         with: "Exam User"
        fill_in "Email",        with: "user@example"
        fill_in "Password",     with: "123456"
        fill_in "Confirmation", with: "123456"
      end

      # it "should 建立新的用户" do
      #  expect { click_button submit }.to change(User, :count).by(1)
      # end
    end

  end

  describe "记住唯一标识符" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "发布微博" do

    before { @user.save }    

    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end

    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "应该有一个正确的排序" do
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end

    it "如果用户被删除了，其所布的所有微博也将被删除" do

      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end

    describe "status" do

      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }

    end
    
  end

  describe "关注" do
    
    let(:other_user) { FactoryGirl.create(:user) }
    
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "followed user" do

      subject { other_user }

      its(:followers) { should include(@user) }

    end

    describe "and unfollowing" do

      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }

    end

  end

  describe "micropost associations" do

    before { @user.save }

    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end

    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    describe "status" do

      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end

      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        @user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "repeat") }
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do
        followed_user.microposts.each do |micropost|
          should include(micropost)
        end
      end

    end

  end

end