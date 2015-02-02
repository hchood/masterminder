import Ember from 'ember';

export default Ember.Component.extend({
  tagName: 'li',
  classNames: ['task-list-item'],

  actions: {
    markTaskComplete: function() {
      var task = this.get('task');
      task.set('completedAt', new Date());
      task.save();
    },

    markTaskIncomplete: function() {
      var task = this.get('task');
      task.set('completedAt', null);
      task.save();
    }
  }
});
