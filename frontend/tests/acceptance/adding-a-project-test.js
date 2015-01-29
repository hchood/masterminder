import Ember from 'ember';
import startApp from '../helpers/start-app';
import Pretender from 'pretender';

var application, server;

module('Acceptance: Adding A Project', {
  setup: function() {
    application = startApp();

    server = new Pretender();
  },
  teardown: function() {
    Ember.run(application, 'destroy');
  }
});

test('authenticated user adds a project', function() {
  server.post('/api/v1/projects', function(request) {
    var projectResponse = {
      name: 'Smite the world with plague of man-eating ladybugs',
      description: 'They will never see it coming.'
    };

    return [201, {"Content-Type": "application/json"}, JSON.stringify({projects: projectResponse})];
  });

  authenticateSession();

  visit('/projects/new');
  fillIn('input[name="name"]', 'Smite the world with plague of man-eating ladybugs');
  fillIn('input[name="description"]', 'They will never see it coming.');

  click('input[type="submit"]');

  andThen(function() {
    equal(currentRouteName(), 'projects.show',
      'Redirected to project show page');
    equal(find('p:contains("Smite the world with plague of man-eating ladybugs")').length, 1);
  });
});

test('form cannot be submitted with missing information', function() {
  server.post('/api/v1/projects', function(request) {
    var errors = {
      name: ["can't be blank"]
    };

    return [422, {"Content-Type": "application/json"}, JSON.stringify({errors: errors})];
  });

  authenticateSession();

  visit('/projects/new');
  click('input[type="submit"]');

  andThen(function() {
    equal(currentRouteName(), 'projects.new', 'Stayed on new project form');
    equal(find('p:contains("can\'t be blank")').length, 1);
  });
});

test('form is not accessible when a user is not logged in', function() {
  invalidateSession();

  // link to add project not displayed
  visit('/');

  andThen(function() {
    equal(find('a:contains("Add a project")').length, 0);
  });

  // cannot navigate to new project form
  visit('/projects/new');

  andThen(function() {
    notEqual(currentRouteName(), 'projects.new');
  });
});
