import Ember from 'ember';

export default Ember.Component.extend({
  tagName: 'li',
  classNames: ['task-list-item'],

  // how do I make this not fire uncontrollably?
  // should it be an action? 
  updateCompletedStatus: function() {
    var task = this.get('task');

    if (task.get('completedAt')) {
      task.set('completedAt', null);
    } else {
      task.set('completedAt', new Date());
    }

    task.save();
  }.observes('task.isCompleted'),
});
