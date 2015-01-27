import Ember from 'ember';
import startApp from '../helpers/start-app';
import Pretender from 'pretender';

var application, server;

module('Acceptance: MarkTaskCompleted', {
  setup: function() {
    application = startApp();

    var project = {
      id: 1,
      name: 'Smite the world with plague of man-eating ladybugs',
      description: 'They will never see it coming.',
      user_id: 3,
      canEdit: true
    };

    var user = {
      id: 3,
      firstName: 'Faizaan',
      lastName: 'The Wizard',
      email: 'faizaan@nefariousschemers.com',
      bio: 'I am an evil schemer.',
      project_ids: [1, 2, 3]
    };

    var tasks = [
      { id: 1,
        project_id: 1,
        name: 'Genetically modify ladybugs'
      }
    ];

    server = new Pretender(function(){
      this.get('/api/v1/projects/:id', function(request) {
        return [200, {"Content-Type": "application/json"}, JSON.stringify({project: project, users: [user], tasks: tasks})];
      });
    });
  },
  teardown: function() {
    Ember.run(application, 'destroy');
  }
});

test('project creator marks task complete', function() {
  authenticateSession();

  visit('/projects/1');
  click('button:contains("Complete")');

  andThen(function() {
    equal(find('button:contains("Complete")').length, 0);
    equal(find('li:contains("Completed")').length, 1);
  });
});

test('other user cannot mark task complete', function() {
  var project = {
    id: 1,
    name: 'Smite the world with plague of man-eating ladybugs',
    description: 'They will never see it coming.',
    user_id: 3,
    canEdit: false
  };

  var user = {
    id: 3,
    firstName: 'Faizaan',
    lastName: 'The Wizard',
    email: 'faizaan@nefariousschemers.com',
    bio: 'I am an evil schemer.',
    project_ids: [1, 2, 3]
  };

  var tasks = [
    { id: 1,
      project_id: 1,
      name: 'Genetically modify ladybugs'
    }
  ];

  server = new Pretender(function(){
    this.get('/api/v1/projects/:id', function(request) {
      return [200, {"Content-Type": "application/json"}, JSON.stringify({project: project, users: [user], tasks: tasks})];
    });
  });

  authenticateSession();

  visit('/projects/1');

  andThen(function() {
    equal(find('button:contains("Complete")').length, 0);
  });
});

test('unauthenticated user cannot mark task complete', function() {
  invalidateSession();

  visit('/projects/1');

  andThen(function() {
    equal(find('button:contains("Complete")').length, 0);
  });
});
