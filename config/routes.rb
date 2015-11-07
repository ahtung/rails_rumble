Rails.application.routes.draw do
  devise_for :users
  resources :organizations, only: :show do
    member do
      get 'sync'
    end
  end
end
