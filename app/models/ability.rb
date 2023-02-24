# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the user here. For example:
    #
    #   return unless user.present?
    #   can :read, :all
    #   return unless user.admin?
    #   can :manage, :all

      # user ||= User.new # guest user (not logged in)
      # if user.admin?
      #   can :manage, :all
      # else
      #   can :read, :all
      # end

    if user.present?
      can :manage, Article, user_id: user.id
      # User can read public and private Articles
      can :read, Article, status: [ 'public','private' ]
      # User can read his own archived articles
      can :read, Article, status: 'archived', user_id: user.id

      can :manage, Comment, user_id: user.id
      can :manage, Like, user_id: user.id
      can :read, Article
      cannot :read, Article do |article|
        article.status == 'archived'
      end
      can :read, Comment, approved: false

      if user.admin?
        can :manage, :all
      elsif user.approver?
        cannot :create, Article
        cannot :create, Like
        can :read, Comment
        cannot :create, Comment
        can :update, Comment
        can :destory, Comment, article: { user_id: !user.id }
        can [ :all_comments, :approve_comments ], Comment
        can :read, Article do |article|
          article.status == 'archived'
        end
      end
    else
      can :read, Article do |article|
        article.status == 'public'
      end
      can :read, Comment, approved: true
    end
    

    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, published: true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md

     # if user.present?
      
    #   can :manage, Article, user_id: user.id
    #   # User can read public and private Articles
    #   can :read, Article, status: [ 'public','private' ]
    #   # User can read his own archived articles
    #   can :read, Article, status: 'archived', user_id: user.id

      
    #   can :manage, Comment, user_id: user.id
    #   # cannot :create, Comment, article: { status: 'private', user_id: !user.id }
    #   can :read, Comment
    #   # User can destroy commets on his own article
    #   # can :destory, Comment, article: { user_id: user.id }

    #   can [ :all_comments, :approve_comments ], Comment
      
    #   can [:create, :destory], Like

    #   # User cannot Create comment on private article
    #   # can :create, Comment, article: { status: 'public' }

    #   if user.admin?
    #     can :manage, :all
    #   elsif user.approver?
        
    #     cannot :create, Article
    #     cannot :create, Like
    #     # cannot [:create, :destory], Like
    #     cannot :create, Comment
    #     can :update, Comment
    #     can :destory, Comment
    #     can [ :all_comments, :approve_comments ], Comment
    #     can :read, Article do |article|
    #       article.status == 'archived'
    #     end
    #   end
    # else
    #   can :read, Comment, approved: true
    #   can :read, Article do |article|
    #     article.status == 'public'
    #   end
    # end


  end
end
