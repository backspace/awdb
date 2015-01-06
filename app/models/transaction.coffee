`import Ember from 'ember'`
`import DS from 'ember-data'`

Transaction = DS.Model.extend
  amount: DS.attr 'number'
  entity: DS.belongsTo 'entity'

  # TODO make actually polymorphic
  fulfillment: DS.belongsTo 'fulfillment'
  contribution: DS.belongsTo 'contribution'
  subscription: DS.belongsTo 'subscription'
  printing: DS.belongsTo 'printing'

  event: Ember.computed.any 'fulfillment', 'contribution', 'subscription', 'printing'

  createdAt: DS.attr 'date', {defaultValue: -> new Date()}

  rev: DS.attr 'string'

`export default Transaction`
