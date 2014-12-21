`import DS from 'ember-data'`

Fulfillment = DS.Model.extend
  issue: DS.belongsTo 'issue'

  subscription: DS.belongsTo 'subscription'
  contribution: DS.belongsTo 'contribution'

  person: DS.belongsTo 'person'

  distribution: DS.belongsTo 'distribution'

  address: DS.attr 'string'

  addressPopulator: Ember.observer 'person.id', ->
    newPersonID = @get 'person.id'

    if @oldPersonID != newPersonID
      person = @get 'person'
      @set 'address', person.get('address') if person?

      @oldPersonID = newPersonID

  rev: DS.attr 'string'

  isForSubscription: Ember.computed.notEmpty 'subscription'
  isForContribution: Ember.computed.notEmpty 'contribution'
  isExtra: Ember.computed 'isForSubscription', 'isForContribution', ->
    !(@get('isForSubscription') || @get('isForContribution'))

`export default Fulfillment`
