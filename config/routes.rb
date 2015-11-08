Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'callbacks' }
  devise_scope :user do
    delete '/users/sign_out' => 'devise/sessions#destroy', as: 'destroy_user_session'
  end
  resources :organizations, only: :show do
    member do
      get 'sync'
    end
  end
end
