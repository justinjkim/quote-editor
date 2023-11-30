Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root to: "pages#home"

  resources :quotes do
    member do
      get "find_author"
    end
  end
end
