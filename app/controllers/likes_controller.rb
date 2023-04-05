class LikesController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!

  def update
    # like = Like.where(article: Article.find(params[:article]), user: current_user)
    # if like == []
    #   Like.create(article: Article.find(params[:article]), user: current_user)
    #   @like_exists = true
    # else
    #   like.destroy_all
    #   @like_exists = false
    # end
    respond_to do |format|
      format.html { }
      format.js { 
        binding.pry;
        # render layout: false
       }
    end
  end

  def create
    @like = current_user.likes.build(like_params)
    if @like.save
      respond_to do |format|
        format.js
      end
    end
    redirect_to @like.article
  end

  def destroy
    @like = current_user.likes.find(params[:id])
    @like.destroy
    respond_to do |format|
      format.js
    end

    redirect_to @like.article
  end

  private

  def like_params
    params.require(:like).permit(:article_id)
  end
end
