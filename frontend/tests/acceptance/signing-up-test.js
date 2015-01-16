import Ember from 'ember';
import startApp from '../helpers/start-app';
import Pretender from 'pretender';

var application, server;

module('Acceptance: SigningUp', {
  setup: function() {
    application = startApp();

    server = new Pretender();
  },
  teardown: function() {
    Ember.run(application, 'destroy');
  }
});

test('user signs up', function() {
  server.post('/api/v1/users', function(request) {
    var userResponse = {
      email: 'wizard@nefariousschemers.com',
      first_name: 'Faizaan',
      last_name: 'Shamsi',
      bio: "That's just my face."
    };

    return [201, {"Content-Type": "application/json"}, JSON.stringify({user: userResponse})];
  });

  visit('/users/new');

  fillIn('input[name="email"]', 'wizard@nefariousschemers.com');
  fillIn('input[name="password"]', 'secretschemes');
  fillIn('input[name="password_confirmation"]', 'secretschemes');
  fillIn('input[name="first_name"]', 'Faizaan');
  fillIn('input[name="last_name"]', 'Shamsi');
  fillIn('textarea[name="bio"]', "That's just my face.");

  click('input[type="submit"]');

  andThen(function() {
    equal(currentPath(), 'users.show',
      'Redirected to user show page');
    equal(find('h3:contains("Faizaan Shamsi\'s Profile")').length, 1);
    // test that a user is logged in, too?
  });
});

test('cannot sign up with missing information', function() {
  server.post('/api/v1/users', function(request) {
    var errors = {
      first_name: ["can't be blank"],
      last_name: ["can't be blank"],
      email: ["can't be blank"],
      password: ["can't be blank"],
      password_confirmation: ["can't be blank"]
    };

    return [422, {"Content-Type": "application/json"}, JSON.stringify({errors: errors})];
  });

  visit('/users/new');
  click('input[type="submit"]');

  andThen(function() {
    equal(currentPath(), 'users.new', 'Stayed on new user form');
    equal(find('p:contains("can\'t be blank")').length, 5);
  });
});
