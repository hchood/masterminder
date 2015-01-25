class ProjectSerializer < ActiveModel::Serializer
  embed :ids

  attributes :id, :name, :description, :can_edit

  has_one :user
  has_many :tasks

  def can_edit
    # once I add a project policy can use that here
    current_user && (current_user == user)
  end
end
