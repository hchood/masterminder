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
  fillIn('textarea[name="description"]', 'They will never see it coming.');

  click('input[type="submit"]');

  andThen(function() {
    equal(find('p:contains("Your evil scheme has been recorded!")').length, 1);
    equal(currentRouteName(), 'projects.show',
      'Redirected to project show page');
  });
});


test('form cannot be submitted with missing information', function() {
  visit('/projects/new');

  andThen(function() {
    equal(find('input[type="submit"]').attr('disabled'), 'disabled',
      'Submit button is disabled');
  });
});
