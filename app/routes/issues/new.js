import Ember from 'ember';

export default Ember.Route.extend({
  controllerName: 'issue.index',

  model: function() {
    return this.store.createRecord('issue');
  },

  renderTemplate: function() {
    this.render('issue.index');
  }
});
