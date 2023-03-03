class RelationshipsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user

  def create
    # RelationshipMailer.started_following_user(@user).deliver_now
    current_user.follow(@user)
    redirect_to profile_path(@user)
  end
  
  def destroy
    # RelationshipMailer.stops_following_user(@user).deliver_now
    current_user.unfollow(@user)
    redirect_to profile_path(@user)
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end


end
