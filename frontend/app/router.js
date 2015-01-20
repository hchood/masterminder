import Ember from 'ember';
import config from './config/environment';

var Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.resource('projects', function() {
    this.route('show', {path: ':id'});
    this.route('new');
  });
  this.route("login");
  this.route("sign-up");

  this.resource("users", function() {
    this.route("show", {path: ':id'});
  });
});

export default Router;
