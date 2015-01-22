require 'rails_helper'

RSpec.describe Task, :type => :model do
  describe "validations" do
    let!(:task) { FactoryGirl.create(:task) }

    it { should validate_presence_of :name }
    it { should validate_presence_of :project }
    it { should validate_uniqueness_of(:name).scoped_to(:project_id) }
  end

  describe "associations" do
    it { should belong_to :project }
  end
end
