class UserSerializer < ActiveModel::Serializer
  embed :ids

  attributes :id,
    :first_name,
    :last_name,
    :email,
    :bio

  has_many :projects
end
