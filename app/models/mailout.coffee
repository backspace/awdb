`import DS from 'ember-data'`

Mailout = DS.Model.extend
  issue: DS.belongsTo 'issue'
  fulfillments: DS.hasMany 'fulfillment'

  createdAt: DS.attr 'date', {defaultValue: -> new Date()}

  rev: DS.attr 'string'

  countByFulfillment: Ember.computed.mapBy 'fulfillments', 'count'
  count: Ember.computed.sum 'countByFulfillment'

  retailFulfillments: Ember.computed.filterBy 'fulfillments', 'isRetail'
  retailCountByFulfillment: Ember.computed.mapBy 'retailFulfillments', 'count'
  retailCount: Ember.computed.sum 'retailCountByFulfillment'

  createContributionTransactions: Ember.on 'didCreate', ->
    @get('issue.features').forEach (feature) =>
      feature.get('contributions').filterBy('isUncompensated').forEach (contribution) =>
        transaction = @store.createRecord 'transaction', {amount: -contribution.get('compensation'), entity: contribution.get('entity'), contribution: contribution}

        transaction.save().then ->
          contribution.set 'transaction', transaction
          contribution.save()

`export default Mailout`
