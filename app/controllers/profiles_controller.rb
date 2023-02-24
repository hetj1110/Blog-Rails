class ProfilesController < ApplicationController
    # load_and_authorize_resource
    before_action :authenticate_user!
      
    def show
        @user = User.find(params[:id])
    end
end
