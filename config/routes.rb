Rails.application.routes.draw do
  resources :articles
  root to: 'search#index'
  get 'search', to: 'search#search'
  get 'search/statistics', to: 'search#statistics'
end
