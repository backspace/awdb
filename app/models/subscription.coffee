`import Ember from 'ember'`
`import DS from 'ember-data'`

Subscription = DS.Model.extend
  entity: DS.belongsTo 'entity', {inverse: 'subscriptions'}
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

    classification = @get('entity.classification')
    # TODO prevent subscription without setting classification?
    classification ?= 'institution'

    cost = settings.get "subscription#{classification.capitalize()}3"

    transaction = @store.createRecord 'transaction', {amount: cost, entity: @get('entity')}
    transaction.save()

`export default Subscription`
