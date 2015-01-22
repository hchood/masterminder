class Api::V1::UsersController < ApplicationController
  def index
    users = User.order(:last_name, :first_name)

    render json: users
  end

  def show
    user = User.includes(:projects).find(params[:id])

    render json: user, include: [:projects]
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
