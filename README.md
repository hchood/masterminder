# Building an app with ember-cli and rails-api

## Overview

This app is a demo for a tutorial on building an app using ember-cli and rails-api being written by [Eric Kelly](https://github.com/heroiceric) and myself. It's an app to help [evil wizards](https://github.com/faizaanshamsi) plan their world domination schemes.  

Our evil wizard users want to add projects (world domination schemes) that have associated tasks.  Their underlings can be assigned to complete those tasks.  Tasks and projects can be tagged with various descriptors such as "kinda evil", "pretty depraved", and so forth.

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

## PART 1 - Projects

## View projects

The first thing our wizards want to do is add a world domination scheme.  Let's first test the pages that'll display those schemes.


```no-highlight
As an evil wizard
I want to view a list of all projects
So that I can see all of the world domination schemes

Acceptance Criteria:
* I see links to all of the world domination schemes.
```

### A. Write a test for the ember app

* Create the acceptance test using the ember-cli generator:

  ```no-highlight
  ember generate acceptance-test projects
  ```

  The ember-cli generator generates the following file for us:

  ```js
  // frontend/tests/acceptance/projects-test.js
  import Ember from 'ember';
  import startApp from '../helpers/start-app';

  var application;

  module('Acceptance: Projects', {
    setup: function() {
      application = startApp();
    },
    teardown: function() {
      Ember.run(application, 'destroy');
    }
  });

  test('visiting /projects', function() {
    visit('/projects');

    andThen(function() {
      equal(currentPath(), 'projects');
    });
  });
  ```

  This created some setup for our tests, as well as a test that's making sure that once we visit the `/projects` path, we're actually on that path.

  Since we haven't created a route for `/projects` yet, this test should fail.  You can see that by navigating to [http://localhost:4200/tests](http://localhost:4200/tests) (make sure your server is running).  You should see something like:
    ![failing test screenshot](https://s3-us-west-2.amazonaws.com/mastermind-ember-tutorial/Screenshot+2015-01-14+21.18.09.png)

    The error tells us we need to create a route, similar if we were to visit a url in a capybara test in Rails where we hadn't started to implement the feature.

    Let's add that route, in the `frontend/app/router.js` file:

    ```js
    Router.map(function() {
      // add this line
      this.resource('projects');
    });
    ```

    Now that test should be passing.

* Add more tests.

  In addition to testing that the route exists, we also want to test some other stuff, such as:

  A. that we can navigate to the `/projects` page from the homepage.

  B. that the correct content appears on our `/projects` page.  Specifically, let's test that the page contains links to each project.

  Add the following tests, plus additional setup. Your test file should look like this:

  ```js
  import Ember from 'ember';
  import startApp from '../helpers/start-app';

  // import pretender addon to mock api response
  import Pretender from 'pretender';

  // make server variable available in your tests (if that is indeed what this line does? IDK maybe I should learn javascript someday)
  var application, server;

  module('Acceptance: Projects', {
    setup: function() {
      application = startApp();

      // create some fake projects for pretender to serve up
      var projects = [
        { id: 1, name: 'Lock up world oil supply' },
        { id: 2, name: 'Tank the U.S. dollar' },
        { id: 3, name: 'Smite the world with plague of man-eating ladybugs' }
      ];

      // use pretender to serve up those fake projects
      server = new Pretender(function(){
        this.get('/api/v1/projects', function(request){
          return [200, {"Content-Type": "application/json"}, JSON.stringify({projects: projects})];
        });
      });
    },
    teardown: function() {
      Ember.run(application, 'destroy');
    }
  });

  // add some tests!

  test('Should allow navigation to the projects page from the landing page', function() {
    visit('/').then(function() {
      click('a:contains("Projects")');
    });

    andThen(function() {
      equal(find('h3').text(), 'All World Domination Schemes');
    });
  });

  test('visiting /projects', function() {
    visit('/projects');

    andThen(function() {
      equal(currentPath(), 'projects.index');

      equal(find('h3:contains("All World Domination Schemes")').length, 1);
      equal(find('a:contains("Lock up world oil supply")').length, 1);
      equal(find('a:contains("Tank the U.S. dollar")').length, 1);
      equal(find('a:contains("Smite the world with plague of man-eating ladybugs")').length, 1);
    });
  });
    ```

    There's one other thing we need to do before we can start making our tests pass.  The setup we just added is using an addon called [ember-cli-pretender](https://github.com/rwjblue/ember-cli-pretender) to mock a response from the Rails API (which we have yet to build).  To use it, we'll need to add the [ember-cli-pretender]() addon:

  ```no-highlight
  cd frontend
  ember install:addon ember-cli-pretender
  ```

  If we start our server and visit [http://localhost:4200/tests](http://localhost:4200/tests), we should see our failing tests.
  
  Now let's make the tests pass.

  1. Add link to `/projects` page

    ```js
    // frontend/app/templates/application.hbs

    <h2 id="title">Mastermind</h2>

    {{link-to 'Projects' 'projects'}}

    {{outlet}}
    ```

  2. Add templates for projects index & show pages

    ```js
    // frontend/app/templates/projects.hbs

    <h3>All World Domination Schemes</h3>

    {{outlet}}  
    ```

    [**NOTE:** Eric says you don't need a `projects.hbs` template but couldn't get test to pass w/o it.]

    ```js
    // frontend/app/templates/projects/index.hbs

    <ul>
      {{#each project in model}}
        <li>{{link-to project.name 'projects.show' project}}</li>
      {{/each}}
    </ul>
    ```

  3. Add routes to projects index and show pages in router

    ```js
    // frontend/app/router.js

    Router.map(function() {
      this.resource('projects', function() {
        this.route('show', {path: ':id'});
      });
    });
    ```

  4. Add route for projects index

    ```no-highlight
    $ ember g route projects/index
    ```

    ```js
    // frontend/app/routes/projects/index.js

    import Ember from 'ember';

    export default Ember.Route.extend({
      model: function() {
        return this.store.find('project');
      },
    });
    ```

  5. Add project model:

    ```no-highlight
    $ ember g model project name:string
    ```

    ```js
    // frontend/app/models/project.js
    import DS from 'ember-data';

    export default DS.Model.extend({
      name: DS.attr('string')
    });
    ```
