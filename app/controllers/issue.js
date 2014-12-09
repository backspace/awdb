import Ember from 'ember';

export default Ember.ObjectController.extend({
  isEditing: false,
  isDistributing: false,

  newFeature: Ember.computed('', function(key, value) {
    var newFeature = this.store.createRecord('feature');

    if (arguments.length > 1) {
      newFeature = value;
    }

    return newFeature;
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
        this.set('newFeature', this.store.createRecord('feature'));

        issue.get('features').pushObject(feature);
        issue.save();
      }.bind(this));
    }
  }
});
