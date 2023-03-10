class ArticleMailer < ApplicationMailer
    def article_creation(article)
        @article = article

        mail(to: @article.user.email, subject: "You have Created New Article")
      end
end
