import Ember from 'ember';

export default Ember.Controller.extend({
  needs: ['projects/show'],
  project: Ember.computed.alias("controllers.projects/show"),

  actions: {
    save: function() {
      var _this = this;
      var project = this.get('project.model');
      var task = this.get('model');

      task.set('project', project);

      task.save().then(function() {
        // this is in rescue mission but i'm not sure it's necessary
        project.get('tasks').pushObject(task);

        var newTask = _this.store.createRecord('task');
        _this.set('model', newTask);
      }, function() {
        // Failed!
        task.set('project', null);
      });
    }
  }
});
