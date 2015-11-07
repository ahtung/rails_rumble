Rails.application.routes.draw do
  resources :organizations, only: :show do
    member do
      get 'sync'
    end
  end
end
