`import Ember from 'ember'`
`import DS from 'ember-data'`

Transaction = DS.Model.extend
  amount: DS.attr 'number'
  person: DS.belongsTo 'person'

  createdAt: DS.attr 'date', {defaultValue: -> new Date()}

  rev: DS.attr 'string'

`export default Transaction`
