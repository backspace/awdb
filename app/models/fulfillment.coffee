`import DS from 'ember-data'`

Fulfillment = DS.Model.extend
  issue: DS.belongsTo 'issue'
  subscription: DS.belongsTo 'subscription'

  rev: DS.attr 'string'

`export default Fulfillment`
