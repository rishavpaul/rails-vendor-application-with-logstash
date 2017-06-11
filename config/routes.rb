Rails.application.routes.draw do

  resources :vendors, only: [:create] do 
    resources :vendor_sales, only: [:create]
    resources :vendor_ratings, only: [:create]
    resources :vendor_items, only: [:create]
  end
  
  resources :items, only: [:create]
end
