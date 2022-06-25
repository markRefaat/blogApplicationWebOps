Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :tags
  resources :comments
  resources :posts
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users, param: :_username, :except => [:create, :update] 
  post '/auth/login', to: 'authentication#login'
  post '/auth/signup', to: 'authentication#signup'
  scope format: true, constraints: { format: /jpg|png|gif|PNG/ } do
    get '/*a', to: 'application#not_found'
  end
end
