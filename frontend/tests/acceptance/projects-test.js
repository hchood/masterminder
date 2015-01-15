import Ember from 'ember';
import startApp from '../helpers/start-app';
import Pretender from 'pretender';

var application, server;

module('Acceptance: Projects', {
  setup: function() {
    application = startApp();

    var projects = [
      { id: 1, name: 'Lock up world oil supply' },
      { id: 2, name: 'Tank the U.S. dollar' },
      { id: 3, name: 'Smite the world with plague of man-eating ladybugs' }
    ];

    server = new Pretender(function(){
      this.get('/api/v1/projects', function(request){
        return [200, {"Content-Type": "application/json"}, JSON.stringify({projects: projects})];
      });
    });
  },
  teardown: function() {
    Ember.run(application, 'destroy');
  }
});

test('visiting /projects', function() {
  visit('/projects');

  andThen(function() {
    equal(currentPath(), 'projects');

    equal(find('h3:contains("All World Domination Schemes")').length, 1);
    equal(find('a:contains("Lock up world oil supply")').length, 1);
    equal(find('a:contains("Tank the U.S. dollar")').length, 1);
    equal(find('a:contains("Smite the world with plague of man-eating ladybugs")').length, 1);
  });
});
