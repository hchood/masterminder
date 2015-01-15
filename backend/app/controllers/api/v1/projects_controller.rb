class Api::V1::ProjectsController < ApplicationController
  def index
    @projects = Project.order(created_at: :desc)

    render json: @projects
  end
end
