Rails.application.routes.draw do
  get 'health/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "posts", to: "posts#index"
  get "posts/:id", to: "posts#show"
  post "/create", to: "posts#create"
  put "/posts/:id", to: "posts#update"
  delete "/posts/:id", to: "posts#destroy"
  get "/user/:id", to: "users#get_user"
  post '/sign_up', to: 'users#create'
  post 'sign_in', to: 'users#sign_in'
  put "/user/:id/update", to: "users#update"
end
