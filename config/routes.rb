Rails.application.routes.draw do
  resources :roles do
    collection do
      post 'sync'
    end
  end
  
  resources :users do
    member do
      put 'deactivate'
      put 'activate'
    end

    collection do
      post 'sync'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
