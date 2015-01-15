require 'rails_helper'

RSpec.describe Api::V1::ProjectsController, :type => :controller do
  describe "GET #index" do
    it "returns all the projects, ordered by recency" do
      older_project = FactoryGirl.create(:project,
        created_at: Time.zone.now - 1.week)
      old_project = FactoryGirl.create(:project,
        created_at: Time.zone.now - 1.day)
      oldest_project = FactoryGirl.create(:project,
        created_at: Time.zone.now - 1.year)

      ordered_projects = [old_project, older_project, oldest_project]

      get :index

      serialized_projects = ActiveModel::ArraySerializer.new(ordered_projects,
        root: projects)

      expect(request.status).to eq 200
      expect(json).to be_json_eq(serialized_questions)
    end
  end

  describe "GET #show" do
    it "returns a project" do
      project = FactoryGirl.create(:project)
      serialized_project = ProjectSerializer.new(project)

      get :show, id: project.id

      expect(request.status).to eq 200
      expect(json).to be_json_eq serialized_question
    end
  end
end
