class Api::V1::UsersController < ApplicationController
  def show
    user = User.find(params[:id])

    render json: user
  end

  def create
    user = User.new(user_params)

    if user.save
      render json: user, location: [:api, :v1, user], status: 201
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :password,
      :password_confirmation,
      :email
    )
  end
end
