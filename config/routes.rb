Rails.application.routes.draw do
  root to: "songs#index"
  resources :songs do
    collection do
      post "create_multiple", to: "songs#create_multiple"
      put "update_multiple", to: "songs#update_multiple", as: "update_multiple"
    end
  end
end
