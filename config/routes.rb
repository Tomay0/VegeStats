Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "application#index"
  get "/stats/:id/user_messages", to: "stats#user_messages", constraints: { id: /\d+/ }
  get "/stats/:id/channel_messages", to: "stats#channel_messages", constraints: { id: /\d+/ }
  get "/stats/:id/top_words", to: "stats#top_words", constraints: { id: /\d+/ }
  get "/stats/:id/user_disproportionate_words", to: "stats#user_disproportionate_words", constraints: { id: /\d+/ }
  get "/stats/:id", to: redirect("/stats/%{id}/user_messages"), constraints: { id: /\d+/ }
  get "/stats/:id/*path", to: redirect("/stats/%{id}/user_messages"), constraints: { id: /\d+/ }
  get "*path", to: redirect("/")
end
