Sixmapp::Application.routes.draw do
  
  get "/dashboard" => 'stream#index', :as => 'dashboard'

  post 'users/create' => 'users#create'
  get 'users/confirm' => 'users#confirm'  
  get '/users/edit' => 'users#edit'
  post '/users/update' => 'users#update' 
  post '/users/resend' => 'users#resend' 
  get '/users/broadcast' => 'users#broadcast'
  post '/users/broadcast_out' => 'users#broadcast_out', :as => 'broadcast_out'
  
  #reset request form
  get '/reset/forgot' => 'reset#new', :as => 'forgot_password' 
  #generates reset link and sends email out
  post '/reset/generate' => 'reset#generate', :as => 'generate'
  #pass word reset form
  get '/reset' => 'reset#password', :as => 'reset'
  #actually resets password
  post '/reset/password' => 'reset#change_password', :as => 'reset_password'

  get '/signup', to: 'users#new', :as => "signup"
  get '/login', to: 'sessions#new', :as => "login"
  post '/verify' => 'sessions#create', :as => 'verify'
  post '/logout' => 'sessions#destroy', :as => 'logout'

  root :to => 'sessions#new'
end
