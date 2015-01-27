class TaskPolicy < ApplicationPolicy
  def create?
    user_created_project?
  end

  def update?
    user_created_project?
  end

  private

  def user_created_project?
    user && (record.project.user == user)
  end
end
