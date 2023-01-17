Rails.application.routes.draw do
  root to: 'domain_data#index'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks'}
  resources :domain_data do
    collection do
      post :import
      get :import_file
      get :generate_insights
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
