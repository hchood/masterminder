require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :controller do
  describe "POST #create" do
    context "as project creator, with valid access token" do
      before :each do
        @project = FactoryGirl.create(:project)

        request.env["HTTP_AUTHORIZATION"] = "Bearer #{@project.user.access_token}"
      end

      it "creates a new project" do
        task_attrs = FactoryGirl.attributes_for(:task)
        task_attrs[:project_id] = @project.id

        prev_count = @project.tasks.count

        post :create, task: task_attrs

        expect(response.status).to eq 201
        expect(@project.tasks.count).to eq prev_count + 1
        expect(json).to be_json_eq TaskSerializer.new(Task.first)
      end

      it "fails if required attributes are missing" do
        task_attrs = {
          project_id: @project.id,
          name: ''
        }

        prev_count = @project.tasks.count

        post :create, task: task_attrs

        expect(response.status).to eq 422
        expect(@project.tasks.count).to eq prev_count
      end
    end

    it "requires authentication" do
      task_attrs = FactoryGirl.attributes_for(:task)

      post :create, task: task_attrs

      expect(response.status).to eq 401
    end

    it "only allows project creator to create task" do
      project = FactoryGirl.create(:project)
      user = FactoryGirl.create(:user)

      request.env["HTTP_AUTHORIZATION"] = "Bearer #{user.access_token}"

      task_attrs = FactoryGirl.attributes_for(:task)
      task_attrs[:project_id] = project.id

      expect{ post :create, task: task_attrs }.to raise_error
    end
  end

  describe "PUT #update" do
    context "as project creator, with valid access token" do
      it "marks a task completed" do
        task = FactoryGirl.create(:task)
        project = task.project

        request.env["HTTP_AUTHORIZATION"] = "Bearer #{project.user.access_token}"

        expect {
          put :update, id: task.id, task: { completed_at: Time.now }
        }.to_not change { Task.count }

        task.reload

        expect(response.status).to eq 200
        expect(task.completed_at).to_not be_nil
        expect(json).to be_json_eq TaskSerializer.new(Task.first)
      end
    end

    it "requires authentication" do
      task = FactoryGirl.create(:task)

      put :update, id: task.id, task: { completed_at: Time.now }

      expect(response.status).to eq 401
    end

    it "only allows project creator to mark task complete" do
      task = FactoryGirl.create(:task)
      user = FactoryGirl.create(:user)

      request.env["HTTP_AUTHORIZATION"] = "Bearer #{user.access_token}"

      expect {
        put :update, id: task.id, task: { completed_at: Time.now }
      }.to raise_error
    end
  end
end
