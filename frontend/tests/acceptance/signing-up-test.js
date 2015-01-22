import Ember from 'ember';
import startApp from '../helpers/start-app';
import Pretender from 'pretender';

var application, server;

module('Acceptance: Signing Up', {
  setup: function() {
    application = startApp();

    server = new Pretender();

    // for this to work, need to specify a 2nd serverTokenEndpoint
    // for simple-auth
    server.post('api/v1/users', function(request) {
      var payload = {
        access_token: "ai38r92y3piurlhkas",
        user_id: 5,
        token_type: "bearer"
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
    expect(0);

    // equal(currentPath(), 'projects.index');
    // equal(find('h3:contains("Welcome, Faizaan!")').length, 1);
    // equal(find('a:contains("Logout")').length, 1);
    // equal(find('a:contains("Login")').length, 0);
  });
});
