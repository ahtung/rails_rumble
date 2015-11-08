Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'callbacks' }
  devise_scope :user do
    delete '/users/sign_out' => 'devise/sessions#destroy', as: 'destroy_user_session'
  end

  authenticated :user do
    root to: "organizations#index", as: 'authenticated_root'
  end

  resources :organizations, only: [:show, :index] do
    member do
      get 'sync'
    end
  end
end
