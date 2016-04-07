Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#index'

  resources :dashboard, only: [:show] do
    member do
      get 'preview'
      get 'show_add_widget/:row_id', to: 'dashboard#show_add_widget', as: 'show_add_widget'
    end

    resources :widgets, only: [:create, :update, :destroy] do
      member do
        post 'wrap'
        post 'unwrap'
        get 'show_settings'
        patch 'update_settings'
      end
    end
  end

end
