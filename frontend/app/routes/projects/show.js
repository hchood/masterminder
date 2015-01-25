import Ember from 'ember';

export default Ember.Route.extend({
  model: function(params) {
    return this.store.find('project', params.id);
  },

  setupController: function(controller, model) {
    this._super(controller, model);
    controller.set('task', this.store.createRecord('task'));
  },
});
