import Ember from 'ember';

export default Ember.Controller.extend({
  needs: ['projects/show'],
  project: Ember.computed.alias("controllers.projects/show"),

  actions: {
    save: function() {
      var _this = this;
      var project = this.get('project.model')
      var task = this.get('model');
debugger;
      task.set('project', project);

      task.save().then(function() {
        // stay on project show page
      }, function() {
        // Failed!
      });
    }
  }
});
