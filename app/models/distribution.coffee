`import DS from 'ember-data'`

Distribution = DS.Model.extend
  issue: DS.belongsTo 'issue'
  fulfillments: DS.hasMany 'fulfillment'

  createdAt: DS.attr 'date', {defaultValue: -> new Date()}

  rev: DS.attr 'string'

  proposedSubscriptionFulfillments: Ember.computed.filterBy 'proposedFulfillments', 'isForSubscription'
  proposedContributionFulfillments: Ember.computed.filterBy 'proposedFulfillments', 'isForContribution'
  proposedExtraFulfillments: Ember.computed.filterBy 'proposedFulfillments', 'isExtra'

`export default Distribution`
