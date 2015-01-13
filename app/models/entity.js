import Ember from 'ember';
import DS from 'ember-data';

import sumBy from 'ember-cpm/macros/sum-by';

var Entity = DS.Model.extend({
  name: DS.attr('string'),
  address: DS.attr('string'),
  email: DS.attr('string'),
  classification: DS.attr('string'),

  isRetailer: DS.attr('boolean', {defaultValue: false}),
  isInstitution: Ember.computed.equal('classification', 'institution'),

  subscriptions: DS.hasMany('subscription', {inverse: 'entity'}),

  fulfillments: DS.hasMany('fulfillment', {async: true}),

  returns: DS.hasMany('return'),

  activeSubscriptions: Ember.computed.filterBy('subscriptions', 'isExhausted', false),
  inactiveSubscriptions: Ember.computed.filterBy('subscriptions', 'isExhausted'),

  isSubscribed: Ember.computed.notEmpty('activeSubscriptions'),
  activeSubscription: Ember.computed.alias('activeSubscriptions.firstObject'),

  hasSubscribed: Ember.computed.notEmpty('subscriptions'),
  isNotSubscribed: Ember.computed.empty('activeSubscriptions'),
  isFormerSubscriber: Ember.computed.and('hasSubscribed', 'isNotSubscribed'),
  isNeverSubscriber: Ember.computed.empty('subscriptions'),

  fulfillmentsRemaining: sumBy('subscriptions', 'remaining'),

  issuesReceived: Ember.computed('subscriptions', function() {
    var subscriptions = this.get('subscriptions');
    return subscriptions.mapBy('fulfillments').reduce(function(flattened, fulfillments) { return flattened.concat(fulfillments.mapBy('issue')); }, []);
  }),

  isAddressless: Ember.computed.empty('address'),

  extraFulfillments: Ember.computed.filterBy('fulfillments', 'isExtra'),
  contributionFulfillments: Ember.computed.filterBy('fulfillments', 'isForContribution'),

  rev: DS.attr('string')
});

Entity.reopenClass({
  classifications: {
    'canada': 'Canada',
    'usa': 'USA',
    'international': 'International',
    'institution': 'Institution'
  }
});

export default Entity;
