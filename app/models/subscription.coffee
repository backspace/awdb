`import Ember from 'ember'`
`import DS from 'ember-data'`

Subscription = DS.Model.extend
  entity: DS.belongsTo 'entity', {inverse: 'subscriptions'}
  count: DS.attr 'number'
  copies: DS.attr 'number'
  cost: DS.attr 'number'

  createdAt: DS.attr 'date', {defaultValue: -> new Date()}
  endedAt: DS.attr 'date'

  isRetail: Ember.computed.alias 'entity.isRetailer'

  fulfillments: DS.hasMany 'fulfillment'

  currentAndFutureFulfillments: Ember.computed 'remaining', ->
    all = [].addObjects @get('fulfillments')
    all.addObject(Ember.Object.create()) for num in [0...@get('remaining')]

    all

  remaining: Ember.computed 'count', 'fulfillments', ->
    @get('count') - @get('fulfillments.length')

  isExhausted: Ember.computed 'remaining', 'isRetail', 'endedAt', ->
    if @get 'isRetail'
      Ember.isPresent(@get('endedAt'))
    else
      @get('remaining') == 0

  rev: DS.attr 'string'

  createTransaction: Ember.on 'didCreate', ->
    unless @get 'isRetail'
      transaction = @store.createRecord 'transaction', {amount: @get('cost'), entity: @get('entity'), subscription: @}
      transaction.save()

  end: ->
    @set 'endedAt', new Date()
    @save()

`export default Subscription`
