class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.text :bio
      t.string :access_token, null: false

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    add_index :users, :access_token, unique: true
  end
end
