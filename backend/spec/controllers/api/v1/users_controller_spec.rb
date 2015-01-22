require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe "POST #create" do
    it "creates a new user" do
      user_attrs = FactoryGirl.attributes_for(:user)

      prev_count = User.count

      post :create, user: user_attrs

      expect(response.status).to eq 201
      expect(User.count).to eq prev_count + 1
      expect(json).to be_json_eq UserSerializer.new(User.first)
    end

    it "fails if required attributes are missing" do
      user_attrs = {
        email: "",
        first_name: "",
        last_name: "",
        password: "",
        password_confirmation: ""
      }

      prev_count = User.count

      post :create, user: user_attrs

      expect(response.status).to eq 422
      expect(User.count).to eq prev_count
    end
  end

  describe "GET #show" do
    it "returns a user" do
      user = FactoryGirl.create(:user)
      projects = FactoryGirl.create_list(:project, 3,
        user: user)

      serialized_user = UserSerializer.new(user, include: [:projects])

      get :show, id: user.id

      expect(response.status).to eq 200
      expect(json).to be_json_eq serialized_user
    end
  end

  describe "GET #index" do
    it "returns all the users, ordered by last name, then first name" do
      last_user = FactoryGirl.create(:user,
        first_name: "Zoe", last_name: "Smith")
      first_user = FactoryGirl.create(:user,
        first_name: "Alex", last_name: "Aaronson")
      middle_user = FactoryGirl.create(:user,
        first_name: "Amanda", last_name: "Smith")

      ordered_users = [first_user, middle_user, last_user]

      get :index

      serialized_users = ActiveModel::ArraySerializer.new(ordered_users,
        root: :users)

      expect(response.status).to eq 200
      expect(json).to be_json_eq(serialized_users)
    end
  end
end
