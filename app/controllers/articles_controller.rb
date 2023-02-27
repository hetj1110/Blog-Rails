class ArticlesController < ApplicationController
  load_and_authorize_resource  
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :set_articles, only: %i[ show edit update destroy ]
  # before_action :authorize_user!, only: [:edit, :update, :destroy]


  def index
    # if current_user
      # @articles = Article.order('created_at desc').select{|article| can?(:read, article)}.page(params[:page])
      # @user_articles = Article.order('created_at desc').find_by(user_id: current_user.id)
    # else
      @articles = Article.order('created_at desc').select{|article| can?(:read, article)}
      @articles = Kaminari.paginate_array(@articles).page(params[:page]).per(10)
    # end
  end

  def show
    @article.update( views: @article.views + 1 )
  end

  def new
    @article = current_user.articles.build
  end
  
  def edit
  end
  
  def create
    
    @article = current_user.articles.build(article_params)
    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_articles
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :subject, :status)
    end

    def authorize_user!
      unless @article.user == current_user
      flash[:notice] = "You are not authorized to perform this action."
      redirect_to article_path(@article)
      end
    end

end
