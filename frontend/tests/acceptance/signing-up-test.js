import Ember from 'ember';
import startApp from '../helpers/start-app';
import Pretender from 'pretender';

var application, server;

module('Acceptance: Signing Up', {
  setup: function() {
    application = startApp();

    server = new Pretender();

    server.post('/api/v1/users', function(request) {
      var payload = {

      };

      return [201, {'Content-Type': 'application/json'}, JSON.stringify(payload)];
    });
  },
  teardown: function() {
    Ember.run(application, 'destroy');
  }
});

test('user signs up', function() {
  visit('/sign-up');

  fillIn('input[name="firstName"]', 'Faizaan');
  fillIn('input[name="lastName"]', 'The Wizard');
  fillIn('input[name="email"]', 'wizard@nefariousschemers.com');
  fillIn('input[name="password"]', 'secretschemes');
  fillIn('input[name="passwordConfirmation"]', 'secretschemes');
  fillIn('input[name="bio"]', 'I am an evil schemer.');

  click('input[type="submit"]');

  andThen(function() {
    equal(currentPath(), 'users.show');
    equal(find('h3:contains("Welcome, Faizaan!")').length, 1);
    
    // This still doesn't pass b/c of issues with simple-auth in test
    equal(find('a:contains("Logout")').length, 1);
  });
});
