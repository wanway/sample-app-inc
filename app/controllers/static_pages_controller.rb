class StaticPagesController < ApplicationController
  def home
  	if signed_in?
  		@micropost = current_user.microposts.build
  		@feed_items = current_user.feed.paginate(page: params[:page])
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
