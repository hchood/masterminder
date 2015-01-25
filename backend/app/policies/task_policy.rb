class TaskPolicy < ApplicationPolicy
  def create?
    user && (record.project.user == user)
  end
end
