Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :projects, only: [:index, :show, :create]
      post '/token' => 'tokens#create'
    end
  end
end
