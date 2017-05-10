Rails.application.routes.draw do
  resources :categories
  resources :ingredients, only:[:index, :show, :edit, :update]
  resources :users
  resources :recipes
  resources :recipe_categories, only:[:new, :create, :destroy]
  resources :subsection_ingredients, only:[:destroy]
  resources :subsections, only:[:destroy]
  resource :session, only: [:new, :create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'recipes#index'
  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'

end
