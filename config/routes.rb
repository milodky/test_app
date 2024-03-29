Rails.application.routes.draw do
  resources :password_resets,     only: [:new, :create, :edit, :update]
  namespace :static_pages do
    get :home
  end
  get 'help' => 'static_pages#help'
  root 'static_pages#home'
  resources :microposts,          only: [:create, :destroy]
  resources :users
  resources :account_activations, only: [:edit]
  resources :relationships,       only: [:create, :destroy]

  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  resources :users do
    # the URLs for following and followers will look like /users/1/following and /users/1/followers
    member do
      get :following, :followers
    end
  end

  # the member method arranges for the routes to respond to URLs containing the user id. The other
  # possibility, collection, works without the id, so that
  #   resources :users do
  #     collection do
  #       get :tigers
  #     end
  #   end
  # would respond to the URL /users/tigers

  get 'signup'  => 'users#new'

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
