class UsersController < ApplicationController
    before_action :authorize_request
    before_action :find_user, except: %i[index]

  # GET /users
  def index
    @users = User.all
    render json: @users.to_json(methods: [:image_url]), status: :ok
  end

  # GET /users/{username}
  def show
    render json: @user, status: :ok
  end

  private

  def find_user
    @user = User.find_by_username!(params[:_username])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'User not found' }, status: :not_found
  end

  def user_params
    params.require(:user).permit(
      :name, :email, :password, :image
    )
  end
end
