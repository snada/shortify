Rails.application.routes.draw do
  resources :shortcuts, only: [:index, :show, :create], path: '', param: :slug
end
