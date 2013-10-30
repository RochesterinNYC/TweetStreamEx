Sixmapp::Application.routes.draw do
  get "/dashboard" => 'stream#index', :as => 'dashboard'

  post 'users/create' => 'users#create'
  get 'users/confirm' => 'users#confirm'  
  get '/confirm_successful', to: redirect('/confsucc.html')
  get '/confirm_failed', to: redirect('/conffail.html')
  get '/users/edit' => 'users#edit'
  post '/users/update' => 'users#update' 

  #reset request form
  get '/reset/forgot' => 'reset#new', :as => 'forgot_password' 
  #generates reset link and sends email out
  post '/reset/generate' => 'reset#generate', :as => 'generate'
  #pass word reset form
  get '/reset' => 'reset#password', :as => 'reset'
  #actually resets password
  post '/reset/password' => 'reset#change_password', :as => 'reset_password'
  get '/reset/successful', to: redirect('/resetsuccess.html')

  get '/signup', to: 'users#new', :as => "signup"
  get '/login', to: 'sessions#new', :as => "login"
  post '/verify' => 'sessions#create', :as => 'verify'
  post '/logout' => 'sessions#destroy', :as => 'logout'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
