class StaticPagesController < ApplicationController
  def home
  	if signed_in?
  		@micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])

      # 私信功能
      @message = current_user.messages.build
  	end
  end

  def help
    @user = User.first

    respond_to do |format|
      format.html
      format.js
    end
  end

  def about
  end

  def contact
  end
end
