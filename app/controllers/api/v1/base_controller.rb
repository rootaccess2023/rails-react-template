class Api::V1::BaseController < ActionController::Base
  protect_from_forgery with: :null_session
  respond_to :json
  
  before_action :authenticate_user_from_token!
  
  private
  
  def authenticate_user_from_token!
    token = request.headers['Authorization']&.sub('Bearer ', '')
    
    if token.present?
      user = User.find_by(authentication_token: token)
      
      if user && !user.token_expired?
        sign_in(user, store: false)
      else
        render json: { error: 'Invalid or expired token' }, status: :unauthorized
      end
    else
      render json: { error: 'Token missing' }, status: :unauthorized
    end
  end
  
  def current_user_json
    {
      id: current_user.id,
      email: current_user.email,
      first_name: current_user.first_name,
      last_name: current_user.last_name,
      created_at: current_user.created_at
    }
  end
end