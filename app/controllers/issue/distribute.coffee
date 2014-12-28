`import Ember from 'ember'`

IssueDistributeController = Ember.ObjectController.extend

  isDistributing: false

  distribution: Ember.computed.alias 'model.distribution'

  entities: Ember.computed.alias 'model.entities'
  subscribers: Ember.computed.filterBy('entities', 'isSubscribed')

  hasNoFulfillments: Ember.computed.empty 'distribution.proposedFulfillments'
  fulfillmentAddresses: Ember.computed.mapBy 'distribution.proposedFulfillments', 'entity.address'
  allFulfillmentsHaveAddresses: Ember.computed 'fulfillmentAddresses.@each', ->
    Ember.isEmpty(@get('fulfillmentAddresses').filter (address) ->
      Ember.isNone(address)
    )
  hasMissingAddresses: Ember.computed.not 'allFulfillmentsHaveAddresses'

  isIncomplete: Ember.computed.any 'hasNoFulfillments', 'hasMissingAddresses'

  waitsForEntitiesToTriggerSuggestions: Ember.observer 'entities.isLoaded', ->
    if @get 'entities.isLoaded'
      @addSuggestedFulfillmentsToDistribution @get('model.distribution')

  addSuggestedFulfillmentsToDistribution: (distribution) ->
    return unless distribution?

    issue = distribution.get 'issue'

    # TODO why does this happen? the store loading the issue elsewhere?
    unless issue
      issue = @get 'model.issue'
      distribution.set 'issue', issue

    # FIXME hideous hack to store fulfillments elsewhere because of broken parent-saving with unsaved children
    distribution.set 'proposedFulfillments', []

    suggestedSubscribers = @get('subscribers').filter (subscriber) ->
      !subscriber.get('issuesReceived').contains(issue)

    suggestedSubscribers.mapBy('activeSubscription').forEach (subscription) =>
      entity = subscription.get 'entity'

      fulfillment = @store.createRecord 'fulfillment', {entity: entity, issue: issue, subscription: subscription}

      distribution.get('proposedFulfillments').pushObject fulfillment

    issue.get('features').forEach (feature) =>
      # FIXME a contributor will receive one issue for each feature
      feature.get('uncompensatedContributions').forEach (contribution) =>
        fulfillment = @store.createRecord 'fulfillment', {entity: contribution.get('entity'), contribution: contribution, issue: issue}

        distribution.get('proposedFulfillments').pushObject fulfillment

  actions:
    distribute: ->
      distribution = @get 'distribution'
      issue = distribution.get('issue')

      @set 'isDistributing', true

      distribution.save().then =>
        Ember.RSVP.all(distribution.get('proposedFulfillments').map((fulfillment) ->
          fulfillment.set 'distribution', distribution
          fulfillment.save()
        )).then((fulfillments) ->
          fulfillments.map((fulfillment) ->
            distribution.get('fulfillments').pushObject fulfillment
            subscription = fulfillment.get('subscription')
            subscription.save() if subscription?

            fulfillment.get('entity').then (entity) ->
              entity.save()
          )
        ).then( ->
          issue.get('distributions').pushObject distribution
          issue.save()
        ).then( ->
          distribution.save()
        ).then =>
          @set 'isDistributing', false
          @send 'showDistribution', distribution

    deleteFulfillment: (fulfillment) ->
      @get('distribution.proposedFulfillments').removeObject(fulfillment)

    addEntity: (entity) ->
      @get('distribution.proposedFulfillments').addObject(@store.createRecord('fulfillment', {entity: entity, issue: @get('distribution.issue')}))

`export default IssueDistributeController`
