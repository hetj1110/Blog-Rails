# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
   

    if user.present?
      can :manage, Article, user_id: user.id
      
      # User can read public and private Articles
      can :read, Article, status: [ 'public','private' ]

      can :search, Article

      # User can read his own archived articles
      can :read, Article, status: 'archived', user_id: user.id

      can :manage, Comment, user_id: user.id
      can :read, Comment

      # can [ :update, :destroy], Comment, article: { status: 'public', user_id: user.id  }
      cannot :create, Comment, article: { status: 'private', user_id: !user.id }

      # User can destroy commets on his own article
      can :destroy, Comment, article: { user_id: user.id }
      
      # User can only approve Comments on his own Articles
      cannot [ :all_comments, :approve_comments ], Comment
      can [:all_comments, :approve_comments], Comment do |comment|
        comment.article.user == user
      end
      
      can [ :update ], Like
      can [:create, :destroy], Like

      can :user_articles, Article

      if user.admin?

        can :manage, :all

      elsif user.approver?

        can :manage, Comment
        cannot :create, Article
        cannot :create, Comment

        can :read, Article do |article|
          article.status == 'archived'
        end
      end

    else
      can :read, Article do |article|
        article.status == 'public'
      end
      can :read, Comment, approved: true
      can :search, Article
    end


  end
end
