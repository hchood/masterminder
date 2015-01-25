class Api::V1::TasksController < ApplicationController
  before_action :ensure_user_authenticated!, only: :create

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

  private

  def task_params
    params.require(:task).permit(:name, :project_id)
  end
end
