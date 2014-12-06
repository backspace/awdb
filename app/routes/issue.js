import Ember from 'ember';

export default Ember.Route.extend({
  model: function(params) {
    return this.store.find('issue', params.issue_id);
  },

  afterModel: function() {
    var self = this;
    return this.store.find('person').then(function(result) {
      window.zz = result;
      self.set('people', result);
    });
  },

  setupController: function(controller, model) {
    this._super(controller, model);
    controller.set('subscribers', this.get('people').filterBy('isSubscribed'));
  }
});
