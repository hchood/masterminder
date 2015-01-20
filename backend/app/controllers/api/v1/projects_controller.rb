class Api::V1::ProjectsController < ApplicationController
  before_action :ensure_user_authenticated!, only: :create

  def index
    @projects = Project.order(created_at: :desc)

    render json: @projects
  end

  def show
    @project = Project.includes(:user).find(params[:id])

    render json: @project, include: [:user]
  end

  def create
    @project = current_user.projects.build(project_params)

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
