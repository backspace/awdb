`import DS from 'ember-data'`

Distribution = DS.Model.extend
  issue: DS.belongsTo 'issue'
  fulfillments: DS.hasMany 'fulfillment'

  createdAt: DS.attr 'date', {defaultValue: -> new Date()}

  rev: DS.attr 'string'

  countByFulfillment: Ember.computed.mapBy 'fulfillments', 'count'
  count: Ember.computed.sum 'countByFulfillment'

  createContributionTransactions: Ember.on 'didCreate', ->
    @get('issue.features').forEach (feature) =>
      feature.get('contributions').forEach (contribution) =>
        transaction = @store.createRecord 'transaction', {amount: -contribution.get('compensation'), entity: contribution.get('entity'), contribution: contribution}

        transaction.save().then ->
          contribution.set 'transaction', transaction
          contribution.save()

`export default Distribution`
