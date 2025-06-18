class Api::V1::UsersController < Api::V1::BaseController
  def show
    render json: {
      user: current_user_json
    }
  end
  
  def update
    if current_user.update(user_params)
      render json: {
        message: 'Profile updated successfully',
        user: current_user_json
      }
    else
      render json: {
        message: 'Update failed',
        errors: current_user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end