require 'rails_helper'

RSpec.describe Api::V1::TokensController, type: :controller do
  describe "POST #create" do
    it "returns user info when provided valid credentials" do
      user = FactoryGirl.create(:user)

      credentials = { username: user.email,
        password: user.password }

      post :create, credentials

      expect(response.status).to eq 201
      expect(json).to be_json_eq({
        access_token: user.access_token,
        token_type: "bearer",
        user_id: user.id })
    end

    it "fails with invalid credentials" do
      credentials = { email: "fakeemail@faker.com",
        password: "fakepassword" }

      post :create

      expect(response.status).to eq 401
      expect(json).to be_json_eq({ errors: "Bad credentials" })
    end
  end
end
