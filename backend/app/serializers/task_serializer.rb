class TaskSerializer < ActiveModel::Serializer
  embed :ids

  attributes :id, :name

  has_one :project
end
