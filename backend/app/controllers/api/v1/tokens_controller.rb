class Api::V1::TokensController < ApplicationController
  def create
    render json: {
      access_token: "2YotnFZFEjr1zCsicMWpAA",
      token_type: "bearer"
    }
  end
end
