class CommentsController < ApplicationController
    load_and_authorize_resource
    before_action :authenticate_user!, except: [:index, :show]
    before_action :set_article, except: [:all_comments, :approve_comments ]
    before_action :set_comment, only: [:show, :edit, :update, :destroy]
    # before_action :authorize_user!, only: [:edit, :update, :destroy]
    # before_action :authorize_approver!, only: [:all_comments, :approve_comments]

    def all_comments
      if current_user.role == 'user'
        @comments = Comment.where(article_id: current_user.articles.pluck(:id)).order('created_at desc').search(params[:search])
      else
        @comments = Comment.all.order('created_at desc').search(params[:search])
      end
      
      if @comments.present?
        @comments = Kaminari.paginate_array(@comments).page(params[:page]).per(8)
      else
        flash[:notice] = "No Result found"
        redirect_to all_comments_path
      end
    end
    
    def approve_comments
      # @comment = Comment.find(params[:id])
      # binding.pry
      # if @comment.update(params[:approved])
      #   flash[:alert] = "Commets have been Approved"
      #   redirect_to unapproved_comments_path
      # else
      #   flash[:alert] = "Commets have not been Approved"
      #   render :all_unapproved_comments
      # end

      params[:comments].each do |key, value|
        comment = Comment.find(key.split(' ').last)
        # binding.pry
        if value == '1'
          comment.update(approved: true)
        else
          comment.update(approved: false)
        end
      end
      flash[:notice] = "Operation performed successfully"
      redirect_to all_comments_path
    end
  
    def new
      @comment = @article.comments.build
    end
  
    def create
      @comment = @article.comments.build(comment_params)
      @comment.user = current_user
      if @comment.save
        CommentMailer.comment_creation(@comment).deliver_now
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
      # @comment.articles.clear
      @comment.destroy

      respond_to do |format|
        format.html { redirect_to article_path(@article), notice: "Comment was successfully destroyed." }
        format.json { head :no_content }
      end

      
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

    # def authorize_user!
    #   unless @comment.user == current_user
    #     flash[:notice] = "You are not authorized to perform this action."
    #     redirect_to article_path(@article)
    #   end
    # end

    # def authorize_approver!
    #   unless current_user && current_user.approver?
    #     redirect_to root_path, alert: "You are not authorized to access this page."
    #   end
    # end

end
  