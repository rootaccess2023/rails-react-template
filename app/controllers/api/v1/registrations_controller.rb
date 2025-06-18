class Api::V1::RegistrationsController < Api::V1::BaseController
  skip_before_action :authenticate_user_from_token!, only: [:create]
  
  def create
    user = User.new(user_params)
    
    if user.save
      user.refresh_token!
      
      render json: {
        message: 'Account created successfully',
        user: current_user_json_for(user),
        token: user.authentication_token
      }, status: :created
    else
      render json: {
        message: 'Registration failed',
        errors: user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end
  
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