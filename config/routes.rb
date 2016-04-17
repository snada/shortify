Rails.application.routes.draw do
  resources :shortcuts, only: [:show, :create], path: '', param: :slug
end
