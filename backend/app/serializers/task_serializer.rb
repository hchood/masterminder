class TaskSerializer < ActiveModel::Serializer
  embed :ids

  attributes :id, :name, :completed_at

  has_one :project
end
