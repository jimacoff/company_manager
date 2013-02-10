CompanyManager::Application.routes.draw do

  resources :monthly_movements, except: [:destroy] do
    resources :sale_inovices do
      collection do
        post :generate_csv
      end
    end
    resources :purchase_invoices do
      collection do
        post :generate_csv
      end
    end
    member do
      put :set_as_send
      put :set_as_finalized
    end
  end

  resources :firms do
    resources :contacts
  end

  devise_for :users
  
  resources :users do
    member do
      get :edit_profile
      put :update_profile
    end
  end
  
  root to: redirect('/users/sign_in')
end
