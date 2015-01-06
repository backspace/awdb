`import DS from 'ember-data'`

Printing = DS.Model.extend
  issue: DS.belongsTo 'issue'
  count: DS.attr 'number'
  cost: DS.attr 'number'

  entity: DS.belongsTo 'entity'

  createdAt: DS.attr 'date', {defaultValue: -> new Date()}

  rev: DS.attr 'string'

  createTransaction: Ember.on 'didCreate', ->
    transaction = @store.createRecord 'transaction', {amount: -@get('cost'), entity: @get('entity'), printing: @}
    transaction.save()

`export default Printing`
