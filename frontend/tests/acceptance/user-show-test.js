import Ember from 'ember';
import startApp from '../helpers/start-app';
import Pretender from 'pretender';

var application, server;

module('Acceptance: UserShow', {
  setup: function() {
    application = startApp();

    // create a fake user
    var user = {
      id: 3,
      firstName: 'Faizaan',
      lastName: 'The Wizard',
      email: 'faizaan@nefariousschemers.com',
      bio: 'I am an evil schemer.',
      project_ids: [1, 2, 3]
    };

    var projects = [
      {
        id: 1,
        name: 'Lock up world oil supply',
        user_id: 3
      },
      {
        id: 2,
        name: 'Tank the U.S. dollar',
        user_id: 3
      },
      {
        id: 3,
        name: 'Smite the world with plague of man-eating ladybugs',
        user_id: 3
      }
    ];

    // mock out response
    server = new Pretender(function(){
      this.get('/api/v1/users/:id', function(request) {
        return [200, {"Content-Type": "application/json"}, JSON.stringify({user: user, projects: projects})];
      });
    });
  },
  teardown: function() {
    Ember.run(application, 'destroy');
  }
});

test('user details are displayed', function() {
  visit('/users/3');

  andThen(function() {
    equal(currentPath(), 'users.show');

    equal(find('h4:contains("Faizaan The Wizard")').length, 1);
    equal(find('div#bio:contains("I am an evil schemer.")').length, 1);

    equal(find('a:contains("Lock up world oil supply")').length, 1);
    equal(find('a:contains("Tank the U.S. dollar")').length, 1);
    equal(find('a:contains("Smite the world with plague of man-eating ladybugs")').length, 1);
  });
});
