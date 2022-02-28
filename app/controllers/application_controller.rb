class ApplicationController < ActionController::Base
    
  #redirect current_user to feed if signed
  def current_user_auhenticate?
    redirect_to feeds_path if user_signed_in?
  end
  
  #redirect current_user to feed if  not signed
  def current_user_unauhenticate
    redirect_to root_path  if !user_signed_in?
  end
  protect_from_forgery with: :exception
    
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected
        # If you have extra params to permit, append them to the sanitizer.
        def configure_permitted_parameters
        sign_up_params          = [ :first_name, :last_name, :full_name, :matricule, :city_name, :level_name,
                                    :material_name, :school_name, :contact, :contact_money, :opt_money,
                                    :nb_class_tle, :nb_class_3e, :current_status, :email,
                                    :password, :slug, :gender]
                                    
        #update_sign_up_params  = [ :school_name, :status, :avatar_profil, :status_payment]
        
        devise_parameter_sanitizer.permit :sign_up, keys: sign_up_params
        devise_parameter_sanitizer.permit :account_update, keys: sign_up_params
        devise_parameter_sanitizer.permit :sign_in, keys: [:logged, :password]
        end 


end
