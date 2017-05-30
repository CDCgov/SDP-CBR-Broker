Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :messages, only: [:show, :index]
  post 'messages/:id/read' => 'messages#mark_message_read'
  post 'messages/read' => 'messages#bulk_mark_messages_read'
  match '/auth/:provider/callback' => 'sessions#create', via: [:get, :post]
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'
end
