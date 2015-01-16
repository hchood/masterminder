class Api::V1::ProjectsController < ApplicationController
  def index
    @projects = Project.order(created_at: :desc)

    render json: @projects
  end

  def show
    @project = Project.find(params[:id])

    render json: @project
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      render json: @project,
        status: 201,
        location: [:api, :v1, @project]
    else
      render json: { errors: @project.errors },
        status: 422
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :description)
  end
end
