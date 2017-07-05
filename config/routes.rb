Rails.application.routes.draw do
  resources :expenditures
	root :to => "frontpage#index"
	
  resources :frontpage do 
  	get :bank_statment, :on => :collection
  end
  resources :categories
  resources :incomes
  devise_for :users
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
