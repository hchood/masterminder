require 'rails_helper'

RSpec.describe Api::V1::ProjectsController, :type => :controller do
  describe "GET #index" do
    it "returns all the projects, ordered by recency" do
      older_project = create(:project,
        created_at: Time.zone.now - 1.week)
      old_project = create(:project,
        created_at: Time.zone.now - 1.day)
      oldest_project = create(:project,
        created_at: Time.zone.now - 1.year)

      ordered_projects = [old_project, older_project, oldest_project]

      get :index

      serialized_projects = ActiveModel::ArraySerializer.new(ordered_projects,
        root: :projects)

      expect(response.status).to eq 200
      expect(json).to be_json_eq(serialized_projects)
    end
  end

  describe "GET #show" do
    it "returns a project" do
      project = create(:project)
      tasks = create_list(:task, 3, project: project)

      serialized_project = ProjectSerializer.new(project, include: [:user, :tasks])

      get :show, id: project.id

      expect(response.status).to eq 200
      expect(json).to be_json_eq serialized_project
    end
  end

  describe "POST #create" do
    context "with valid access token" do
      before :each do
        @current_user = create(:user)
        request.env["HTTP_AUTHORIZATION"] = "Bearer #{@current_user.access_token}"
      end

      it "creates a new project" do
        project_attrs = attributes_for(:project)

        prev_count = Project.count

        post :create, project: project_attrs

        expect(response.status).to eq 201
        expect(Project.count).to eq prev_count + 1
        expect(json).to be_json_eq ProjectSerializer.new(Project.first,
          scope: @current_user)
      end

      it "fails if required attributes are missing" do
        project_attrs = { name: '' }

        prev_count = Project.count

        post :create, project: project_attrs

        expect(response.status).to eq 422
        expect(Project.count).to eq prev_count
      end
    end

    it "requires authentication" do
      project_attrs = attributes_for(:project)

      post :create, project: project_attrs

      expect(response.status).to eq 401
    end
  end
end
