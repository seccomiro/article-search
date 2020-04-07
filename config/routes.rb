Rails.application.routes.draw do
  resources :articles
  root to: 'search#index'
  get 'search/statistics', to: 'search#statistics'
  get 'search', to: 'search#search'
end
