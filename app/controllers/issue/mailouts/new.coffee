`import Ember from 'ember'`

NewMailoutController = Ember.ObjectController.extend

  isSaving: false

  mailout: Ember.computed.alias 'model.mailout'

  entities: Ember.computed.alias 'model.entities'
  subscribers: Ember.computed.filterBy('model.entities', 'isSubscribed')

  hasNoFulfillments: Ember.computed.empty 'mailout.proposedFulfillments'
  fulfillmentAddresses: Ember.computed.mapBy 'mailout.proposedFulfillments', 'entity.address'
  allFulfillmentsHaveAddresses: Ember.computed 'fulfillmentAddresses.@each', ->
    Ember.isEmpty(@get('fulfillmentAddresses').filter (address) ->
      Ember.isNone(address)
    )
  hasMissingAddresses: Ember.computed.not 'allFulfillmentsHaveAddresses'

  isIncomplete: Ember.computed.any 'hasNoFulfillments', 'hasMissingAddresses'

  waitsForEntitiesToTriggerSuggestions: Ember.observer 'entities.isLoaded', ->
    if @get 'entities.isLoaded'
      @addSuggestedFulfillmentsToMailout @get('model.mailout')

  addSuggestedFulfillmentsToMailout: (mailout) ->
    return unless mailout?

    issue = mailout.get 'issue'

    # TODO why does this happen? the store loading the issue elsewhere?
    unless issue
      issue = @get 'model.issue'
      mailout.set 'issue', issue

    # FIXME hideous hack to store fulfillments elsewhere because of broken parent-saving with unsaved children
    mailout.set 'proposedFulfillments', []

    # FIXME having to refilter entities.isSubscribed here rather than rely on computed subscribers, why?
    suggestedSubscribers = @get('model.entities').filterBy('isSubscribed').filter (subscriber) ->
      !subscriber.get('issuesReceived').contains(issue)

    suggestedSubscribers.mapBy('activeSubscription').forEach (subscription) =>
      entity = subscription.get 'entity'

      fulfillment = @store.createRecord 'fulfillment', {entity: entity, issue: issue, subscription: subscription}

      mailout.get('proposedFulfillments').pushObject fulfillment

    issue.get('features').forEach (feature) =>
      # FIXME a contributor will receive one issue for each feature
      feature.get('uncompensatedContributions').forEach (contribution) =>
        fulfillment = @store.createRecord 'fulfillment', {entity: contribution.get('entity'), contribution: contribution, issue: issue, count: @settings.get('featureComplimentaryIssues')}

        mailout.get('proposedFulfillments').pushObject fulfillment

  actions:
    save: ->
      mailout = @get 'mailout'
      issue = mailout.get('issue')

      @set 'isSaving', true

      mailout.save().then =>
        Ember.RSVP.all(mailout.get('proposedFulfillments').map((fulfillment) ->
          fulfillment.set 'mailout', mailout
          fulfillment.save()
        )).then((fulfillments) ->
          fulfillments.map((fulfillment) ->
            mailout.get('fulfillments').pushObject fulfillment
            subscription = fulfillment.get('subscription')
            subscription.save() if subscription?

            fulfillment.get('entity').then (entity) ->
              entity.save()
          )
        ).then( ->
          issue.get('mailouts').pushObject mailout
          issue.save()
        ).then( ->
          mailout.save()
        ).then =>
          @set 'isSaving', false
          @send 'showMailout', mailout

    deleteFulfillment: (fulfillment) ->
      @get('mailout.proposedFulfillments').removeObject(fulfillment)

    addEntity: (entity) ->
      @get('mailout.proposedFulfillments').addObject(@store.createRecord('fulfillment', {entity: entity, issue: @get('mailout.issue')}))

`export default NewMailoutController`
