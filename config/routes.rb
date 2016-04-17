Rails.application.routes.draw do
  resources :short_urls, only: [:show, :create], path: '', param: :slug
end
