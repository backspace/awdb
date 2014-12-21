`import Ember from 'ember'`
`import DS from 'ember-data'`

Contribution = DS.Model.extend
  feature: DS.belongsTo 'feature'
  person: DS.belongsTo 'person'

  rev: DS.attr 'string'

`export default Contribution`
