Rails.application.routes.draw do
  resources :songs do
    collection do
      post "create_multiple", to: "songs#create_multiple"
    end
  end
end
