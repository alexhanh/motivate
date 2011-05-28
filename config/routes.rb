Gr::Application.routes.draw do
  devise_for :users

  resources :products do
    resources :food_units
    resources :food_entries
  end
  
  resources :recipes do
    resources :food_entries
    resources :ingredients
  end
  
  match 'badges' => 'achievements#index', :as => :achievements
  
  match 'goals' => 'goals#update', :as => :update_goals, :via => :put
  match 'goals' => 'goals#index', :as => :goals
  
  match 'settings' => 'settings#update', :as => :update_settings, :via => :put
  match 'settings' => 'settings#index', :as => :settings

  match 'mockup/room' => 'mockup#room'
  
  resources :exercise_entries
  
  match 'recipes/find_ingredient/:ingredient_id' => 'recipes#find_ingredient'
  match 'recipes/add_ingredient' => 'recipes#add_ingredient'
  match 'recipes/:id/remove_ingredient/:ingredient_id' => 'recipes#remove_ingredient'
  
  # hack to display food_entries (since they are nested)
  match 'eaten' => 'food_entries#listtest', :as => :eaten
  
  match 'favorites/add/:favorable_type/:favorable_id' => 'favorites#add', :as => :add_to_favorites
  match 'favorites/remove/:favorable_type/:favorable_id' => 'favorites#remove', :as => :remove_from_favorites
  match 'favorites/' => 'favorites#index', :as => :favorites
  
  resources :food_entries
  
  resources :tracker_entries do
    collection do
      post 'change_tracker'
    end
  end
  
  #devise_for :users
  #resource :users

  root :to => "products#index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
