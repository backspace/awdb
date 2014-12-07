import Ember from 'ember';

export default Ember.ObjectController.extend({
  isEditing: false,
  isDistributing: false,

  newFeature: Ember.computed('', function() {
    return this.store.createRecord('feature');
  }),

  actions: {
    distribute: function() {
      var store = this.store;

      var issue = this.get('model');

      this.set('isDistributing', true);
      var controller = this;

      return Ember.RSVP.all(this.get('subscribers').mapBy('activeSubscription').map(function(subscription) {
        var fulfillment = store.createRecord('fulfillment', {issue: issue, subscription: subscription});
        return fulfillment.save();
      })).then(function(fulfillments) {
        return fulfillments.map(function(fulfillment) {
          return fulfillment.get('subscription').save();
        });
      }).then(function() {
        controller.set('isDistributing', false);
      });
    },

    saveNewFeature: function() {
      var issue = this.get('model');
      var feature = this.get('newFeature');

      feature.set('issue', issue);
      feature.save().then(function() {
        issue.get('features').pushObject(feature);
        issue.save();
      });
    }
  }
});
