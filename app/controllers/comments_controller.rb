class CommentsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :set_article
    before_action :set_comment, only: [:edit, :update, :destroy]
    before_action :authorize_user!, only: [:edit, :update, :destroy]
  
    def index
      @comments = @article.comments
    end
  
    def show
      @comment = @article.comments.find(params[:id])
    end
  
    def new
      @comment = @article.comments.new
    end
  
    def create
      @comment = @article.comments.build(comment_params)
      @comment.user = current_user
      if @comment.save
        redirect_to [@article, @comment]
      else
        render :new
      end
    end
  
    def edit
    end
  
    def update
      if @comment.update(comment_params)
        redirect_to [@article, @comment]
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
      @comment = Comment.find(params[:id])
    end
  
    def comment_params
      params.require(:comment).permit(:content, :approved)
    end
  
    def authorize_user!
      unless @comment.user == current_user
        flash[:alert] = "You are not authorized to perform this action."
        redirect_to article_comments_path(@article)
      end
    end
end
  