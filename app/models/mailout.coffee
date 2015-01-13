`import DS from 'ember-data'`
`import sumBy from 'ember-cpm/macros/sum-by'`

Mailout = DS.Model.extend
  issue: DS.belongsTo 'issue'
  fulfillments: DS.hasMany 'fulfillment'

  createdAt: DS.attr 'date', {defaultValue: -> new Date()}

  rev: DS.attr 'string'

  count: sumBy 'fulfillments', 'count'

  retailFulfillments: Ember.computed.filterBy 'fulfillments', 'isRetail'
  retailCount: sumBy 'retailFulfillments', 'count'

  createContributionTransactions: Ember.on 'didCreate', ->
    @get('issue.features').forEach (feature) =>
      feature.get('contributions').filterBy('isUncompensated').forEach (contribution) =>
        transaction = @store.createRecord 'transaction', {amount: -contribution.get('compensation'), entity: contribution.get('entity'), contribution: contribution}

        transaction.save().then ->
          contribution.set 'transaction', transaction
          contribution.save()

`export default Mailout`
