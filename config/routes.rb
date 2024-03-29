Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#index'

  resources :dashboard, only: [:show] do
    member do
      get 'preview/:mode', to: 'dashboard#preview', as: 'preview'
      get 'show_add_widget/:row_id', to: 'dashboard#show_add_widget', as: 'show_add_widget'
      put :increase_version
    end

    resources :widgets, only: [:create, :update, :destroy] do
      member do
        post 'wrap'
        post 'unwrap'
        patch 'update_position'
        get 'show_settings'
        patch 'update_settings'
      end
    end
  end

end
