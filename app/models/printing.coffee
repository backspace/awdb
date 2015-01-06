`import DS from 'ember-data'`

Printing = DS.Model.extend
  issue: DS.belongsTo 'issue'
  count: DS.attr 'number'

  entity: DS.belongsTo 'entity'

  rev: DS.attr 'string'

`export default Printing`
