import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  address: DS.attr('string'),

  subscriptions: DS.hasMany('subscription', {inverse: 'person'}),

  isSubscribed: function() {
    return this.get('subscriptions').filterBy('isExhausted', false).get('length') > 0;
  }.property('subscriptions.@each.isExhausted'),

  subscriptionFulfillmentsRemaining: Ember.computed.mapBy('subscriptions', 'remaining'),
  fulfillmentsRemaining: Ember.computed.sum('subscriptionFulfillmentsRemaining'),

  rev: DS.attr('string')
});
