`import Ember from 'ember'`
`import DS from 'ember-data'`

Subscription = DS.Model.extend
  person: DS.belongsTo 'person', {inverse: 'subscriptions'}
  count: DS.attr 'number'

  fulfillments: DS.hasMany 'fulfillment'

  remaining: Ember.computed 'fulfillments', ->
    @get('count') - @get('fulfillments.length')

  isExhausted: Ember.computed 'remaining', ->
    @get('remaining') == 0

  rev: DS.attr 'string'

`export default Subscription`
