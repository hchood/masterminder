import DS from 'ember-data';

export default DS.Model.extend({
  firstName: DS.attr('string'),
  lastName: DS.attr('string'),
  email: DS.attr('string'),
  password: DS.attr('string'),
  passwordConfirmation: DS.attr('string'),
  bio: DS.attr('string'),

  projects: DS.hasMany('project', { async: true }),

  fullName: function() {
    return this.get('firstName') + ' ' + this.get('lastName');
  }.property('firstName', 'lastName'),

  welcomeMessage: function() {
    return 'Welcome, ' + this.get('firstName') + '!'
  }.property('firstName')
});
