Rails.application.routes.draw do
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
