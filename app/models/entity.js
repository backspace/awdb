import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  address: DS.attr('string'),
  classification: DS.attr('string'),

  isRetailer: DS.attr('boolean', {defaultValue: false}),

  subscriptions: DS.hasMany('subscription', {inverse: 'entity'}),

  fulfillments: DS.hasMany('fulfillment'),

  activeSubscriptions: Ember.computed.filterBy('subscriptions', 'isExhausted', false),
  isSubscribed: Ember.computed.notEmpty('activeSubscriptions'),
  activeSubscription: Ember.computed.alias('activeSubscriptions.firstObject'),

  hasSubscribed: Ember.computed.notEmpty('subscriptions'),
  isNotSubscribed: Ember.computed.empty('activeSubscriptions'),
  isFormerSubscriber: Ember.computed.and('hasSubscribed', 'isNotSubscribed'),

  subscriptionFulfillmentsRemaining: Ember.computed.mapBy('subscriptions', 'remaining'),
  fulfillmentsRemaining: Ember.computed.sum('subscriptionFulfillmentsRemaining'),

  issuesReceived: Ember.computed('subscriptions', function() {
    var subscriptions = this.get('subscriptions');
    return subscriptions.mapBy('fulfillments').reduce(function(flattened, fulfillments) { return flattened.concat(fulfillments); }).mapBy('issue');
  }),

  rev: DS.attr('string')
});
