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

  resources :profiles, only: [:show]

  resources :articles do
    resources :comments, only: [ :create, :edit, :update, :destroy]
  end

  get '/comments/all_comments', to: 'comments#all_comments',as: 'all_comments'
  patch '/comments/approve_comments', to: 'comments#approve_comments', as: 'approving_comments'

  root 'home#index'
  
  get 'confirmation_panding', to: "home#after_registration_path"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
