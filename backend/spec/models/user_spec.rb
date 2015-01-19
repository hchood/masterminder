require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    let!(:user) { FactoryGirl.create(:user) }

    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }

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
end
