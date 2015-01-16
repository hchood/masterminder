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

test('user adds a project', function() {
  server.post('/api/v1/projects', function(request) {
    var projectResponse = {
      name: 'Smite the world with plague of man-eating ladybugs',
      description: 'They will never see it coming.'
    };

    return [201, {"Content-Type": "application/json"}, JSON.stringify({projects: projectResponse})];
  });

  visit('/projects/new');
  fillIn('input[name="name"]', 'Smite the world with plague of man-eating ladybugs');
  fillIn('input[name="description"]', 'They will never see it coming.');

  click('input[type="submit"]');

  andThen(function() {
    equal(currentRouteName(), 'projects.show',
      'Redirected to project show page');
    equal(find('h3:contains("Smite the world with plague of man-eating ladybugs")').length, 1);
  });
});

test('form cannot be submitted with missing information', function() {
  server.post('/api/v1/projects', function(request) {
    var errors = {
      name: ["can't be blank"]
    };

    return [422, {"Content-Type": "application/json"}, JSON.stringify({errors: errors})];
  });

  visit('/projects/new');
  click('input[type="submit"]');

  andThen(function() {
    equal(currentRouteName(), 'projects.new', 'Stayed on new project form');
    equal(find('p:contains("can\'t be blank")').length, 1);
  });
});
