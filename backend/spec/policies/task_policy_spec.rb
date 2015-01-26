require 'rails_helper'

describe TaskPolicy do
  subject { described_class }
  let(:task) { FactoryGirl.build(:task) }

  permissions :create? do
    it "is not permitted as a visitor" do
      expect(subject).to_not permit(nil, task)
    end

    it "is permitted as a user who created the project" do
      user = task.project.user

      expect(subject).to permit(user, task)
    end

    it "is not permitted as a different user" do
      expect(subject).to_not permit(User.new, task)
    end
  end

  permissions :update? do
    it "is not permitted as a visitor" do
      expect(subject).to_not permit(nil, task)
    end

    it "is permitted as a user who created the project" do
      user = task.project.user

      expect(subject).to permit(user, task)
    end

    it "is not permitted as a different user" do
      expect(subject).to_not permit(User.new, task)
    end
  end
end
