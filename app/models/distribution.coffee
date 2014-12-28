`import DS from 'ember-data'`

Distribution = DS.Model.extend
  issue: DS.belongsTo 'issue'
  fulfillments: DS.hasMany 'fulfillment'

  createdAt: DS.attr 'date', {defaultValue: -> new Date()}

  rev: DS.attr 'string'

  # TODO DRY this up

  subscriptionFulfillments: Ember.computed.filterBy 'fulfillments', 'isForSubscription'
  retailSubscriptionFulfillments: Ember.computed.filterBy 'fulfillments', 'isForRetailSubscription'
  contributionFulfillments: Ember.computed.filterBy 'fulfillments', 'isForContribution'
  extraFulfillments: Ember.computed.filterBy 'fulfillments', 'isExtra'

  proposedSubscriptionFulfillments: Ember.computed.filterBy 'proposedFulfillments', 'isForSubscription'
  proposedRetailSubscriptionFulfillments: Ember.computed.filterBy 'proposedFulfillments', 'isForRetailSubscription'
  proposedContributionFulfillments: Ember.computed.filterBy 'proposedFulfillments', 'isForContribution'
  proposedExtraFulfillments: Ember.computed.filterBy 'proposedFulfillments', 'isExtra'

  createContributionTransactions: Ember.on 'didCreate', ->
    @get('issue.features').forEach (feature) =>
      feature.get('contributions').forEach (contribution) =>
        transaction = @store.createRecord 'transaction', {amount: -contribution.get('compensation'), entity: contribution.get('entity'), contribution: contribution}

        transaction.save().then ->
          contribution.set 'transaction', transaction
          contribution.save()

`export default Distribution`
