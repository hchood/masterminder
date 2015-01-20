class Api::V1::TokensController < ApplicationController
  def create
    user = User.find_by(email: params[:username])
      .try(:authenticate, params[:password])

    if user.present?
      render json: {
        access_token: user.access_token,
        token_type: "bearer",
        user_id: user.id
      }, status: 201
    else
      render json: { errors: "Bad credentials" }, status: 401
    end
  end
end
