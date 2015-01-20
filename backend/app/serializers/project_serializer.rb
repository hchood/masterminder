class ProjectSerializer < ActiveModel::Serializer
  embed :ids

  attributes :id, :name, :description

  has_one :user
end
