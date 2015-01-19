import Ember from 'ember';
import AuthControllerMixin from 'simple-auth/mixins/authentication-controller-mixin';

export default Ember.Controller.extend(AuthControllerMixin, {
  authenticator: 'simple-auth-authenticator:oauth2-password-grant',

  actions: {
    signUp: function(user) {
      var _this = this;
      var identification = user.get('email');
      var password = user.get('password');
      var options = {
        identification: identification,
        password: password
      };

      user.save().then(function(user) {
        _this.send('authenticate', options);
        debugger;
        // _this.transitionTo('users.show', model);
      }, function(response) {
        // save didnt workered
      });
    }
  }
});
