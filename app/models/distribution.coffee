`import DS from 'ember-data'`

Distribution = DS.Model.extend
  issue: DS.belongsTo 'issue'
  fulfillments: DS.hasMany 'fulfillment'

  createdAt: DS.attr 'date', {defaultValue: -> new Date()}

  rev: DS.attr 'string'

`export default Distribution`
