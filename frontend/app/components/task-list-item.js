import Ember from 'ember';

export default Ember.Component.extend({
  tagName: 'li',
  classNames: ['task-list-item'],

  actions: {
    saveTask: function() {
      var task = this.get('task');
      task.set('completedAt', new Date());
      task.save().then(function() {
        console.log(task.completedAt);
      });
    }
  }
});
