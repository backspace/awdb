import Ember from 'ember';

export default Ember.Route.extend({
  model: function() {
    return this.store.find('issue');
  },

  actions: {
    createIssue: function() {
      this.transitionTo('issues.new');
    }
  }
});
