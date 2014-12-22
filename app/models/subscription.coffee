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
    # FIXME should be injected
    settings = @container.lookup 'settings:main'

    classification = @get('person.classification')
    # TODO prevent subscription without setting classification?
    classification ?= 'institution'
    titleClassification = classification[0].toUpperCase() + classification.slice(1)

    cost = settings.get "subscription#{titleClassification}3"

    transaction = @store.createRecord 'transaction', {amount: cost, person: @get('person')}
    transaction.save()

`export default Subscription`
