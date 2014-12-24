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

  isForSubscription: Ember.computed.notEmpty 'subscription'
  isForContribution: Ember.computed.notEmpty 'contribution'
  isExtra: Ember.computed 'isForSubscription', 'isForContribution', ->
    !(@get('isForSubscription') || @get('isForContribution'))

`export default Fulfillment`
