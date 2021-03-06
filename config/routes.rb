Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'playlist_generator#index'

  post 'playlist/create', :to => 'playlist_generator#create'

  get '/auth/spotify/callback', to: 'playlist_generator#spotify'
end
