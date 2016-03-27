InsalesApp::Application.routes.draw do
  root to: 'main#index'
  get '/get_products', to: 'main#get_products'
  get '/put_product', to: 'main#put_product'

  resource  :session do
    collection do
      get :autologin
    end
  end

  get '/install',   to: 'insales_app#install',   as: :install
  get '/uninstall', to: 'insales_app#uninstall', as: :uninstall
  get '/login',     to: 'sessions#new',          as: :login
  get '/main',      to: 'main#index',            as: :main

  get ':controller/:action/:id'
  get ':controller/:action/:id.:format'
end
