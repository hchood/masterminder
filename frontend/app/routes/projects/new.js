import Ember from 'ember';

export default Ember.Route.extend({
  model: function() {
    return this.store.createRecord('project');
  },
  actions: {
    save: function() {
      var _this = this;
      var model = this.currentModel;

      model.save().then(function() {
        _this.transitionTo('projects.show', model);
      }, function() {
        // Failed!
      });
    }
  }
});
