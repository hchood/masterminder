Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :projects, only: [:index, :show, :create]
      resources :users, only: [:index, :show, :create]
      resources :tasks, only: [:index, :show, :create, :update]

      post '/token' => 'tokens#create'
    end
  end
end
