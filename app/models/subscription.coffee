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

  createTransaction: Ember.on 'didCreate', ->
    classification = @get('person.classification')
    cost = 30 if classification == 'canada'
    cost = 35 if classification == 'usa'
    cost = 40 if classification == 'international'
    cost = 45 unless classification?

    transaction = @store.createRecord 'transaction', {amount: cost, person: @get('person')}
    transaction.save()

`export default Subscription`
