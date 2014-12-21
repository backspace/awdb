`import DS from 'ember-data'`

Fulfillment = DS.Model.extend
  issue: DS.belongsTo 'issue'

  subscription: DS.belongsTo 'subscription'
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
  isForContribution: Ember.computed.empty 'subscription'

`export default Fulfillment`
