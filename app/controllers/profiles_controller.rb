class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:follower_list, :following_list]

  def show
    @user = User.find(params[:id])
  end

  def follower_list
    @followers = @user.followers
  end

  def following_list
    @following = @user.following
  end

  private

  def set_user
    @user = User.find(params[:profile_id])
  end
end
