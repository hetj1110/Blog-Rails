class ArticlesController < ApplicationController
    before_action :authenticate_user!, except: %i[ index show ]
    before_action :set_articles, only: %i[ show edit update destroy ]
    before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @articles = Article.all.order('created_at desc')
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
    binding.pry
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
      params.require(:article).permit(:title, :subject, :body, :status)
    end

    def authorize_user!
      unless @article.user == current_user
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to article_path(@article)
      end
    end

end
