Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#index'

  resources :dashboard, only: [:show] do
    member do
      post :add_widget
    end
  end

end
