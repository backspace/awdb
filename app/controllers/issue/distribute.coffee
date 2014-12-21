`import Ember from 'ember'`

IssueDistributeController = Ember.ObjectController.extend
  needs: 'issue'

  isDistributing: false

  subscribers: Ember.computed.filterBy('controllers.issue.people', 'isSubscribed')

  addSuggestedFulfillmentsToDistribution: (distribution) ->
    return unless distribution?

    issue = distribution.get 'issue'

    # FIXME hideous hack to store fulfillments elsewhere because of broken parent-saving with unsaved children
    distribution.set 'proposedFulfillments', []

    suggestedSubscribers = @get('subscribers').filter (subscriber) ->
      !subscriber.get('issuesReceived').contains(issue)

    suggestedSubscribers.mapBy('activeSubscription').forEach (subscription) =>
      person = subscription.get 'person'

      fulfillment = @store.createRecord 'fulfillment', {person: person, address: person.get('address'), issue: issue, subscription: subscription}

      distribution.get('proposedFulfillments').pushObject fulfillment

    issue.get('features').forEach (feature) =>
      # FIXME a contributor will receive one issue for each feature
      feature.get('contributors').forEach (contributor) =>
        # TODO almost duplication of above fulfillment creation, just without subscription
        fulfillment = @store.createRecord 'fulfillment', {person: contributor, address: contributor.get('address'), issue: issue}

        distribution.get('proposedFulfillments').pushObject fulfillment

  actions:
    distribute: ->
      distribution = @get 'model'
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

            fulfillment.get('person').save()
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
      @get('model.proposedFulfillments').removeObject(fulfillment)

`export default IssueDistributeController`
