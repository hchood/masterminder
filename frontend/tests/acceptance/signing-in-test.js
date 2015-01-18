import Ember from 'ember';
import startApp from '../helpers/start-app';
import Pretender from 'pretender';

var application, server;

module('Acceptance: Signing In', {
  setup: function() {
    application = startApp();

    server = new Pretender();
  },
  teardown: function() {
    Ember.run(application, 'destroy');
  }
});

test('user signs in', function() {
  server.post('/users/sign_in', function(request) {
    var payload = {
      user_token: 'gvSkMer7hZpw9iZsBZ4r',
      user_id: 3
    };

    return [201, {'Content-Type': 'application/json'}, JSON.stringify(payload)];
  });

  visit('/login');

  fillIn('input[name="email"]', 'wizard@nefariousschemers.com');
  fillIn('input[name="password"]', 'secretschemes');

  click('input[type="submit"]');

  andThen(function() {
    // logout button should appear
    equal(find('a:contains("Logout")').length, 1);

    // LATER: test that (1) logging in takes you to the projects index page
    // and (2) user's name is displayed

    // equal(currentPath(), 'projects.index', 'Redirected to projects index page');
    // equal(find('li:contains("Welcome, Faizaan!")').length, 1);
  });
});
