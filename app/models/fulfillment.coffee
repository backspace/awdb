`import DS from 'ember-data'`

Fulfillment = DS.Model.extend
  issue: DS.belongsTo 'issue'

  subscription: DS.belongsTo 'subscription'
  contribution: DS.belongsTo 'contribution'

  entity: DS.belongsTo 'entity', {async: true}

  distribution: DS.belongsTo 'distribution'

  name: DS.attr 'string'
  address: DS.attr 'string'

  count: DS.attr 'number', {defaultValue: 1}

  # TODO must be a better way to copy name and address
  nameAndAddressPopulator: Ember.observer 'entity.id', ->
    return unless @get('isNew')

    newEntityID = @get 'entity.id'

    if @oldEntityID != newEntityID
      entity = @get 'entity'
      @set 'name', entity.get('name') if entity?
      @set 'address', entity.get('address') if entity?

      @oldEntityID = newEntityID

  rev: DS.attr 'string'

  countAndCostPopulator: Ember.observer 'subscription.copies', 'subscription.cost', ->
    return unless @get('isNew')
    if @get 'isRetail'
      @set('count', @get('subscription.copies'))
      @set('cost', @get('subscription.cost'))

  isRetail: Ember.computed.alias 'entity.isRetailer'
  isNotRetail: Ember.computed.not 'isRetail'

  # TODO rename non-retail subscriptions?
  isForSomeSubscription: Ember.computed.notEmpty 'subscription'

  isForSubscription: Ember.computed.and 'isForSomeSubscription', 'isNotRetail'
  isForRetailSubscription: Ember.computed.and 'isForSomeSubscription', 'isRetail'

  isForContribution: Ember.computed.notEmpty 'contribution'

  isNotExtra: Ember.computed.or 'isForSomeSubscription', 'isForContribution'
  isExtra: Ember.computed.not 'isNotExtra'

  createTransaction: Ember.on 'didCreate', ->
    if @get 'isRetail'
      transaction = @store.createRecord 'transaction', {amount: @get('cost')*@get('count'), entity: @get('entity'), fulfillment: @}
      transaction.save()

`export default Fulfillment`
