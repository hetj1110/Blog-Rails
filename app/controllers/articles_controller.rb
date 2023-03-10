class ArticlesController < ApplicationController
  load_and_authorize_resource  
  before_action :authenticate_user!, except: %i[ index show search ]
  before_action :set_articles, only: %i[ show edit update destroy ]


  def index
      @articles = Article.order('created_at desc').search(params[:search]).select{|article| can?(:read, article)}
      if @articles.present?
        @articles = Kaminari.paginate_array(@articles).page(params[:page]).per(8)
      else
        flash[:notice] = "No Result found"
        redirect_to articles_path
      end
  end

  def user_articles
    @articles = current_user.articles.order('created_at desc').search(params[:search]).page(params[:page]).per(5)
  end

  def show
    @user = User.find_by(params[:user_id])
    @article.update( views: @article.views + 1 )
    @like_exists = Like.where(article: @article, user: @user) == [] ? false : true
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
        ArticleMailer.article_creation(@article).deliver_now
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
      params.require(:article).permit(:title, :subject, :status, :body)
    end

end
