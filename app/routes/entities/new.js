import Ember from 'ember';

export default Ember.Route.extend({
  controllerName: 'entity',

  model: function() {
    return this.store.createRecord('entity');
  },

  renderTemplate: function() {
    this.render('entity', {into: 'application'});
  }
});
