Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "application#index"
  get "/stats/:id", to: "stats#index", constraints: { id: /\d+/ }
  get "/stats/:id/user_messages", to: "stats#user_messages", constraints: { id: /\d+/ }
  get "/stats/:id/channel_messages", to: "stats#channel_messages", constraints: { id: /\d+/ }
  get "/stats/:id/*path", to: redirect("/stats/%{id}")
  get "*path", to: redirect("/")
end
