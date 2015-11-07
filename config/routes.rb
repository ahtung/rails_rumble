Rails.application.routes.draw do
  resources :organizations, only: :show
end
