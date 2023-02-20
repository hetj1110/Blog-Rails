class CommentsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :set_article, except: [:all_comments, :approve_comments]
    before_action :set_comment, only: [:show, :edit, :update, :destroy]
    before_action :authorize_user!, only: [:edit, :update, :destroy]
  
    def index
      @comments = @article.comments
    end

    def all_comments
      @comments = Comment.all#.where(approved: false)
    end

    def approve_comments
    end
  
    def new
      @comment = @article.comments.build
    end
  
    def create
      @comment = @article.comments.build(comment_params)
      @comment.user = current_user
      if @comment.save
        redirect_to article_path(@article)
      else
        render :new
      end
    end
  
    def edit
    end
  
    def update
      if @comment.update(comment_params)
        redirect_to article_path(@article)
      else
        render :edit
      end
    end
  
    def destroy
      @comment.destroy
      redirect_to article_comments_path(@article)
    end
  
    private
  
    def set_article
      @article = Article.find(params[:article_id])
    end
  
    def set_comment
      # @comment = Comment.find(params[:id])
      @comment = @article.comments.find(params[:id])
    end
  
    def comment_params
      params.require(:comment).permit(:content)
    end

    def authorize_user!
      unless @comment.user == current_user
        flash[:alert] = "You are not authorized to perform this action."
        redirect_to article_comments_path(@article)
      end
    end
end
  