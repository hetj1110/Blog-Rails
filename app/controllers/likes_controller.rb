class LikesController < ApplicationController
    before_action :authenticate_user!
    
    def create
        @like = current_user.likes.build(like_params)
        if !@like.save
          flash[:notice] = "You have already liked this Article"
        end
        redirect_to @like.article
    end

    def destroy
        @like = current_user.likes.find(params[:id])
        @like.destroy

        redirect_to @like.article
    end

    private

    def like_params
        params.require(:like).permit(:article_id)
    end
end
