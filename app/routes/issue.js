import Ember from 'ember';

export default Ember.Route.extend({
  model: function(params) {
    return this.store.find('issue', params.issue_id);
  },

  afterModel: function() {
    return this.store.find('person').then(function(result) {
      this.set('people', result);
    }.bind(this));
  },

  setupController: function(controller, model) {
    this._super(controller, model);
    controller.set('people', this.get('people'));
    controller.set('subscribers', this.get('people').filterBy('isSubscribed'));
  }
});
