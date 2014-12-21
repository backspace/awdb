`import DS from 'ember-data'`

Fulfillment = DS.Model.extend
  issue: DS.belongsTo 'issue'

  subscription: DS.belongsTo 'subscription'
  person: DS.belongsTo 'person'

  distribution: DS.belongsTo 'distribution'

  # TODO can be derived from person
  address: DS.attr 'string'

  rev: DS.attr 'string'

`export default Fulfillment`
