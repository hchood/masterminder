require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    let!(:user) { FactoryGirl.create(:user) }

    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }

    it { should validate_confirmation_of :password}

    it { should validate_uniqueness_of :email }
    it { should validate_uniqueness_of :access_token }
  end

  describe "before_validation callback" do
    it "sets the access token" do
      user = FactoryGirl.build(:user)
      expect(user.access_token).to be_nil

      user.save
      expect(user.access_token).to_not be_nil
    end
  end

  describe ".from_request" do
    it "finds access token from request authorization" do
      request = double(authorization: "Bearer ABC")
      expect(User).to receive(:find_by).with(access_token: 'ABC')
      User.from_request(request)
    end

    it "fails gracefully when request has no authorization" do
      request = double(authorization: nil)
      expect { User.from_request(request) }.to_not raise_error
    end
  end
end
