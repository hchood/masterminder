import Ember from 'ember';
import Session from 'simple-auth/session';

export default {
  name: 'authentication',

  initialize: function(container) {
    Session.reopen({
      currentUser: function() {
        var userId = this.get('user_id');
        if (Ember.isPresent(userId)) {
          return container.lookup('store:main').find('user', userId);
        }
      }.property('user_id')
    });
  }
};
