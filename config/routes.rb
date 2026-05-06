Rails.application.routes.draw do
  root "dashboard#index"

  resources :tareas, only: %i[new create edit update destroy] do
    member { patch :toggle }
  end

  post "ai/sugerencia", to: "ai#sugerencia", as: :ai_sugerencia

  get "up" => "rails/health#show", as: :rails_health_check
end
