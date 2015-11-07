Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "callbacks" }
  resources :organizations, only: :show do
    member do
      get 'sync'
    end
  end
end
