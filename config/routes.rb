Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  root 'index#index'
  get 'oauth/authorize' => 'oauth#authorize', as: :oauth_authorize
  get 'oauth/callback' => 'oauth#callback', as: :oauth_callback

  get 'login' => 'sessions#new', as: :login
  delete 'logout' => 'sessions#destroy', as: :logout
  resources :sessions, :only => [:create]

  resources :trades
  resources :banters
  resources :rosters, :only => [:index, :show]

  namespace :yahoo do
    get 'request/transactions' => 'request#transactions', as: :refresh_transactions
    get 'request/rosters' => 'request#rosters', as: :import_rosters
    get 'request/players' => 'request#players', as: :import_players
  end

  namespace :google do
    get 'request/read' => 'request#read', as: :read_spreadsheet
    get 'request/write_transaction' => 'request#write_transaction', as: :write_transaction
    get 'oauth/callback' => 'oauth#callback', as: :oauth_callback
    get 'oauth/authorize' => 'oauth#authorize', as: :oauth_authorize
  end

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
