import Ember from 'ember';

export default Ember.Controller.extend({
  // // This does not set model -- still undefined
  // setupController: function(controller, task) {
  //   controller.set('model', task);
  // },

  actions: {
    save: function() {
      var _this = this;
      var model = this.get('model');
      debugger;

      model.save().then(function() {
        debugger;
        // need to transistion to project show page, not task show page
        // _this.transitionTo('projects.show', model);
      }, function() {
        // Failed!
      });
    }
  }
});
