Rails.application.routes.draw do
  
  root to:"welcome#index"
  get "feeds", to:'home#index'
   get "teams", to:'home#team'
  
       ######### USER DATA #########
            devise_scope :user do
    get 'profile/edit'    => 'devise/registrations#edit',   :as => :edit_user_registration
    get 'profile/cancel'  => 'devise/registrations#cancel', :as => :cancel_user_registration
  end

  devise_for :users, path: '', path_names: { sign_in: 'Connecter', 
                sign_out: 'logout', password: 'secret', confirmation: 'verification',
                 unlock: 'unblock', registration: '', sign_up: 'student' }
  
end
