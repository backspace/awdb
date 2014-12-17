import Ember from 'ember';

export default Ember.Route.extend({
  model: function() {
    return this.store.find('issue');
  },

  actions: {
    createIssue: function() {
      var newIssue = this.get('store').createRecord('issue');
      this.transitionTo('issue', newIssue.save());
    }
  }
});
