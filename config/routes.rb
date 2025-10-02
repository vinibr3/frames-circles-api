Rails.application.routes.draw do
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'

  get "up" => "rails/health#show", as: :rails_health_check

  # root "posts#index"

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :frames, only: %i[create destroy show] do
        resources :circles, only: %i[create], controller: 'frames/circles'
      end
      resources :circles, only: %i[update destroy]
    end
  end
end
