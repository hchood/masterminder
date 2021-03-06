import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  description: DS.attr('string'),
  user: DS.belongsTo('user', { async: true }),
  tasks: DS.hasMany('task', { async: true }),

  canEdit: DS.attr('boolean', { defaultValue: false })
});
