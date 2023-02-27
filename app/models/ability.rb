# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)

    # if user.present?
    #   can :manage, Article, user_id: user.id
    #   # User can read public and private Articles
    #   can :read, Article, status: [ 'public','private' ]
    #   # User can read his own archived articles
    #   can :read, Article, status: 'archived', user_id: user.id

    #   can :manage, Comment, user_id: user.id
    #   can :manage, Like, user_id: user.id
    #   can :read, Comment

    #   if user.admin?
    #     can :manage, :all
    #   elsif user.approver?
    #     cannot :create, Article
    #     cannot :create, Like
    #     can :read, Comment
    #     cannot :create, Comment
    #     can :update, Comment
    #     can :destroy, Comment
    #     can [ :all_comments, :approve_comments ], Comment
    #     can :read, Article do |article|
    #       article.status == 'archived'
    #     end
    #   end
    # else
    #   can :read, Article do |article|
    #     article.status == 'public'
    #   end
    #   can :read, Comment, approved: true
    # end
    

    if user.present?
      can :manage, Article, user_id: user.id
      # User can read public and private Articles
      can :read, Article, status: [ 'public','private' ]
      # User can read his own archived articles
      can :read, Article, status: 'archived', user_id: user.id

      can :manage, Comment, user_id: user.id
      can :read, Comment
      can [ :update, :destroy], Comment, article: { status: 'public', user_id: user.id  }
      # cannot :create, Comment, article: { status: 'private', user_id: !user.id }
      # User can destroy commets on his own article
      can :manage, Comment, article: { user_id: user.id }
      
      can [ :all_comments, :approve_comments ], Comment
      
      can [:create, :destroy], Like

      # User cannot Create comment on private article
      # cannot :create, Comment, article: { status: 'private' }, user_id: !user.id

      if user.admin?
        can :manage, :all
      elsif user.approver?
        cannot :create, Article
        cannot :create, Comment
        can :update, Comment
        can :destroy, Comment
        can [ :all_comments, :approve_comments ], Comment
        can :read, Article do |article|
          article.status == 'archived'
        end
      end
    else
      can :read, Comment, approved: true
      can :read, Article do |article|
        article.status == 'public'
      end
    end


  end
end
