`import DS from 'ember-data'`

Fulfillment = DS.Model.extend
  issue: DS.belongsTo 'issue'

  subscription: DS.belongsTo 'subscription'
  contribution: DS.belongsTo 'contribution'

  entity: DS.belongsTo 'entity'

  distribution: DS.belongsTo 'distribution'

  address: DS.attr 'string'

  addressPopulator: Ember.observer 'entity.id', ->
    newEntityID = @get 'entity.id'

    if @oldEntityID != newEntityID
      entity = @get 'entity'
      @set 'address', entity.get('address') if entity?

      @oldEntityID = newEntityID

  rev: DS.attr 'string'

  isRetail: Ember.computed.alias 'entity.isRetailer'
  isNotRetail: Ember.computed.not 'isRetail'

  # TODO rename non-retail subscriptions?
  isForSomeSubscription: Ember.computed.notEmpty 'subscription'

  isForSubscription: Ember.computed.and 'isForSomeSubscription', 'isNotRetail'
  isForRetailSubscription: Ember.computed.and 'isForSomeSubscription', 'isRetail'

  isForContribution: Ember.computed.notEmpty 'contribution'

  isNotExtra: Ember.computed.or 'isForSomeSubscription', 'isForContribution'
  isExtra: Ember.computed.not 'isNotExtra'

`export default Fulfillment`
