Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }

  devise_scope :user do
    delete '/users/:id/delete_avatar', to: 'users/registrations#delete_avatar', as: 'delete_user_avatar'
  end

  resources :profiles, only: [:show] #do
  #   get '/follower_list', to: 'profiles#follower_list', as: "followers"
  #   get '/following_list', to: 'profiles#following_list', as: "following"
  # end

  post 'relationships/create', to: 'relationships#create', as: "follow_user"
  delete 'relationships/destroy', to: 'relationships#destroy', as: "unfollow_user"

  resources :likes, only: [:create, :destroy]
  get 'likes/update'

  get '/search', to: "articles#search"
  
  resources :articles do
    collection do
      get 'user_articles'
    end
    resources :comments, only: [ :create, :edit, :update, :destroy]
  end

  get '/articles/user_articles', to: 'articles#user_articles'

  get '/comments/all_comments', to: 'comments#all_comments',as: 'all_comments'
  patch '/comments/approve_comments', to: 'comments#approve_comments', as: 'approving_comments'

  root 'home#index'
  
  get 'confirmation_panding', to: "home#after_registration_path"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # To handle Routing Error
  # match '*unmatched', to: 'application#not_found_method', via: :all

end
