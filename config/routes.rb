Rails.application.routes.draw do
  get 'search', to: 'search#index'
  get 'search/statistics', to: 'search#statistics'
  get 'search/:term', to: 'search#search'
end
