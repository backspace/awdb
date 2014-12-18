import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  address: DS.attr('string'),

  subscriptions: DS.hasMany('subscription', {inverse: 'person'}),

  activeSubscriptions: Ember.computed.filterBy('subscriptions', 'isExhausted', false),
  isSubscribed: Ember.computed.notEmpty('activeSubscriptions'),
  activeSubscription: Ember.computed.alias('activeSubscriptions.firstObject'),

  subscriptionFulfillmentsRemaining: Ember.computed.mapBy('subscriptions', 'remaining'),
  fulfillmentsRemaining: Ember.computed.sum('subscriptionFulfillmentsRemaining'),

  issuesReceived: Ember.computed('subscriptions', function() {
    var subscriptions = this.get('subscriptions');
    return subscriptions.mapBy('fulfillments').reduce(function(flattened, fulfillments) { return flattened.concat(fulfillments); }).mapBy('issue');
  }),

  rev: DS.attr('string')
});
