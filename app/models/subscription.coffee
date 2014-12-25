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

  remaining: Ember.computed 'fulfillments', ->
    @get('count') - @get('fulfillments.length')

  isExhausted: Ember.computed 'remaining', 'isRetail', 'endedAt', ->
    if @get 'isRetail'
      Ember.isPresent(@get('endedAt'))
    else
      @get('remaining') == 0

  rev: DS.attr 'string'

  createTransaction: Ember.on 'didCreate', ->
    unless @get 'isRetail'
      # FIXME should be injected
      settings = @container.lookup 'settings:main'

      classification = @get('entity.classification')
      # TODO prevent subscription without setting classification?
      classification ?= 'institution'

      # FIXME assumes only 3 or 6 issues
      cost = settings.get "subscription#{classification.capitalize()}#{@get 'count'}"

      transaction = @store.createRecord 'transaction', {amount: cost, entity: @get('entity')}
      transaction.save()

  end: ->
    @set 'endedAt', new Date()
    @save()

`export default Subscription`
