class ProfilesController < ApplicationController
  # load_and_authorize_resource
  before_action :authenticate_user!
  # before_action :set_user, only: [:follower_list, :following_list]

  def show
    @user = User.find(params[:id])
  end

  # def follower_list
  #   @followers = @user.followers
  # end

  # def following_list
  #   # binding.pry
  #   @following = @user.following
  # end

  # private

  # def set_user
  #   @user = User.find(params[:user_id])
  # end
end
