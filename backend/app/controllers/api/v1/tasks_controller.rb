class Api::V1::TasksController < ApplicationController
  before_action :ensure_user_authenticated!, only: [:create, :update]

  def show
    @task = Task.find(params[:id])

    render json: @task
  end

  def create
    @task = Task.new(task_params)

    authorize @task

    if @task.save
      render json: @task,
        status: 201,
        location: [:api, :v1, @task]
    else
      render json: { errors: @task.errors }, status: 422
    end
  end

  def update
    @task = Task.find(params[:id])

    authorize @task

    if @task.update(task_params)
      render json: @task
    else
      render json: { errors: @task.errors }, status: 422
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :project_id, :completed_at)
  end
end
