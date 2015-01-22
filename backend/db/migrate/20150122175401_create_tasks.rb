class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :project_id, null: false
      t.string :name, null: false

      t.timestamps null: false
    end

    add_index :tasks, [:project_id, :name], unique: true
  end
end
