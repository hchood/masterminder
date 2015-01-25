import Ember from 'ember';

export default Ember.Controller.extend({
  actions: {
    save: function() {
      var _this = this;
      var model = this.store.createRecord('task');

      model.save().then(function() {
        // stay on project show page
      }, function() {
        // Failed!
      });
    }
  }
});
