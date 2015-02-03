require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :controller do
  describe "GET #index" do
    it "returns most recent 25 tasks" do
      oldest_task = create(:task, created_at: 1.week.ago)
      newest_task = create(:task)
      older_task  = create(:task, created_at: 2.days.ago)

      ordered_tasks = [newest_task, older_task, oldest_task]

      get :index

      expect(response.status).to eq 200
      expect(json).to be_json_eq ActiveModel::ArraySerializer.new(ordered_tasks,
        root: :tasks)
    end

    context "with task ids" do
      it "returns a subset of tasks" do
        oldest_task = create(:task, created_at: 1.week.ago)
        newest_task = create(:task)
        older_task  = create(:task, created_at: 2.days.ago)

        requested_tasks = [newest_task, oldest_task]

        get :index, ids: [newest_task.id, oldest_task.id]

        expect(response.status).to eq 200
        expect(json).to be_json_eq ActiveModel::ArraySerializer.new(requested_tasks,
          root: :tasks)
      end
    end
  end

  describe "GET #show" do
    it "returns a task's details" do
      task = create(:task)

      serialized_task = TaskSerializer.new(task)

      get :show, id: task.id

      expect(response.status).to eq 200
      expect(json).to be_json_eq serialized_task
    end
  end

  describe "POST #create" do
    context "as project creator, with valid access token" do
      before :each do
        @project = create(:project)

        request.env["HTTP_AUTHORIZATION"] = "Bearer #{@project.user.access_token}"
      end

      it "creates a new task" do
        task_attrs = attributes_for(:task)
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
      task_attrs = attributes_for(:task)

      post :create, task: task_attrs

      expect(response.status).to eq 401
    end

    it "only allows project creator to create task" do
      project = create(:project)
      user = create(:user)

      request.env["HTTP_AUTHORIZATION"] = "Bearer #{user.access_token}"

      task_attrs = attributes_for(:task)
      task_attrs[:project_id] = project.id

      expect{ post :create, task: task_attrs }.to raise_error
    end
  end

  describe "PUT #update" do
    context "as project creator, with valid access token" do
      it "marks a task completed" do
        task = create(:task)
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
      task = create(:task)

      put :update, id: task.id, task: { completed_at: Time.now }

      expect(response.status).to eq 401
    end

    it "only allows project creator to mark task complete" do
      task = create(:task)
      user = create(:user)

      request.env["HTTP_AUTHORIZATION"] = "Bearer #{user.access_token}"

      expect {
        put :update, id: task.id, task: { completed_at: Time.now }
      }.to raise_error
    end
  end
end
