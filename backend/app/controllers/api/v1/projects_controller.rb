class Api::V1::ProjectsController < ApplicationController
  def index
    @projects = Project.order(created_at: :desc)

    render json: @projects
  end

  def show
    @project = Project.find(params[:id])

    render json: @project
  end
end
