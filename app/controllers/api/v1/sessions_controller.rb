class Api::V1::SessionsController < Api::V1::BaseController
  skip_before_action :authenticate_user_from_token!, only: [:create]
  
  def create
    user = User.find_by(email: params[:email])
    
    if user&.valid_password?(params[:password])
      user.refresh_token!
      
      render json: {
        message: 'Logged in successfully',
        user: current_user_json_for(user),
        token: user.authentication_token
      }, status: :ok
    else
      render json: {
        error: 'Invalid email or password'
      }, status: :unauthorized
    end
  end
  
  def destroy
    if current_user
      current_user.update(authentication_token: nil, token_expires_at: nil)
      render json: { message: 'Logged out successfully' }, status: :ok
    else
      render json: { error: 'Not logged in' }, status: :unauthorized
    end
  end
  
  private
  
  def current_user_json_for(user)
    {
      id: user.id,
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name,
      created_at: user.created_at
    }
  end
end