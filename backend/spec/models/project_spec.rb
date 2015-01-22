require 'rails_helper'

RSpec.describe Project, :type => :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :user }

    it { should belong_to :user }
    it { should have_many(:tasks).dependent(:destroy) }
  end
end
