`import Ember from 'ember'`
`import DS from 'ember-data'`

Retailer = DS.Model.extend
  name: DS.attr 'string'
  address: DS.attr 'string'

  rev: DS.attr 'string'

`export default Retailer`
