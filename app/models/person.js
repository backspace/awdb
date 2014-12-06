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

  rev: DS.attr('string')
});
