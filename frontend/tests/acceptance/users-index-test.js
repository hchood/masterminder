import Ember from 'ember';
import startApp from '../helpers/start-app';
import Pretender from 'pretender';

var application, server;

module('Acceptance: Users Index page', {
  setup: function() {
    application = startApp();

    var users = [
      {
        id: 1,
        first_name: 'Faizaan',
        last_name: 'The Wizard'
      },
      {
        id: 2,
        first_name: 'Bob',
        last_name: 'Loblaw'
      },
      {
        id: 3,
        first_name: 'Gene',
        last_name: 'Parmesan'
      }
    ];

    server = new Pretender(function(){
      this.get('/api/v1/users', function(request){
        return [200, {"Content-Type": "application/json"}, JSON.stringify({users: users})];
      });
    });
  },
  teardown: function() {
    Ember.run(application, 'destroy');
  }
});

test('visiting /users', function() {
  visit('/');
  click('a:contains("Users")');

  andThen(function() {
    equal(find('a:contains("Faizaan The Wizard")').length, 1);
    equal(find('a:contains("Bob Loblaw")').length, 1);
    equal(find('a:contains("Gene Parmesan")').length, 1);
  });
});
