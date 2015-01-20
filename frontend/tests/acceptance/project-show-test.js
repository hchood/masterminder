import Ember from 'ember';
import startApp from '../helpers/start-app';

// import pretender
import Pretender from 'pretender';

// declare server variable
var application, server;

module('Acceptance: ProjectShow', {
  setup: function() {
    application = startApp();

    // create a fake project
    var project = {
      id: 1,
      name: 'Smite the world with plague of man-eating ladybugs',
      description: 'They will never see it coming.',
      user_id: 3
    };

    var user = {
      id: 3,
      firstName: 'Faizaan',
      lastName: 'The Wizard',
      email: 'faizaan@nefariousschemers.com',
      bio: 'I am an evil schemer.',
      project_ids: [1, 2, 3]
    };

    // mock out response
    server = new Pretender(function(){
      this.get('/api/v1/projects/:id', function(request) {
        return [200, {"Content-Type": "application/json"}, JSON.stringify({project: project, users: [user]})];
      });
    });
  },
  teardown: function() {
    Ember.run(application, 'destroy');
  }
});

// modify existing test
test('project details are displayed', function() {
  visit('/projects/1');

  andThen(function() {
    equal(currentPath(), 'projects.show');

    equal(find('h3:contains("Smite the world with plague of man-eating ladybugs")').length, 1);
    equal(find('div#description:contains("They will never see it coming.")').length, 1);

    equal(find('a:contains("Faizaan The Wizard")').length, 1);
  });
});
