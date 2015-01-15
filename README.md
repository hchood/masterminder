# Building an app with ember-cli and rails-api

## Overview

This app is a demo for a tutorial on building an app using ember-cli and rails-api being written by [Eric Kelly](https://github.com/heroiceric) and myself. It's an app to help [evil wizards](https://github.com/faizaanshamsi) plan their world domination schemes.

## Setup

* Create the top-level app directory:

  ```no-highlight
  mkdir masterminder
  cd masterminder
  ```

* Create the ember app inside your app directory.  Rename it `frontend/`.

  ```no-highlight
  ember-cli new masterminder --skip-git
  mv masterminder frontend
  ```

* Create the rails-api app using Postgres. Rename it `backend/`.

  ```no-highlight
  rails-api new mastermind -T --database=postgresql
  mv masterminder backend
  ```

* Initialize a git repo in your top-level app directory:

  ```no-highlight
  cd ..
  git init
  git add -A
  git commit -m "Initial commit."
  ```

* Add `active_model_serializers` gem and testing and debugging gems and bundle. Commit your changes. **Make sure to specify version 0.8.3 for active_model_serializers if you're using Rails 4.2! (which you should be).**

  ```ruby
  # Gemfile

  gem 'active_model_serializers', '0.8.3'

  group :test do
    gem 'shoulda-matchers', require: false
  end

  group :development, :test do
    gem 'factory_girl_rails'
    gem 'faker'
    gem 'pry-rails'
    gem 'rspec-rails', '~> 3.0.0'
  end
  ```

  ```no-highlight
  cd backend
  bundle install
  git add -A
  git commit -m "Add active_model_serializers, debugging and testing gems."
  ```

* [PROLLY DO THIS STEP LATER] Add a rake task to start up your Rails and Ember apps.

  You should be able to access your Ember app at `http://localhost:4200` once you start the server:

  ```no-highlight
  cd ../frontend
  ember server
  ```

  Your Rails app, meanwhile, can be accessed at `http://localhost:3000`

  Let's add a rake task that will start up both those servers from your top-level directory.  Create a `Rakefile` in your top-level directory containing the following:

  ```ruby
  require "rake"

  task :run do
    pids = [
      spawn("cd backend && rails s"),
      spawn("cd frontend && ./node_modules/.bin/ember server --proxy http://localhost:3000"),
    ]

    trap "INT" do
      Process.kill "INT", *pids
      exit 1
    end

    loop do
      sleep 1
    end
  end
  ```

  Now running `rake run` should start up both your rails and ember servers.
