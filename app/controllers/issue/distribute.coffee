`import Ember from 'ember'`

IssueDistributeController = Ember.ObjectController.extend
  needs: 'issue'

  isDistributing: false

  subscribers: Ember.computed.filterBy('controllers.issue.people', 'isSubscribed')

  suggestedSubscriptions: Ember.computed 'subscribers', ->
    issue = @get 'model'

    @get('subscribers').filter (subscriber) =>
      !subscriber.get('issuesReceived').contains(issue)

  actions:
    distribute: ->
      issue = @get 'model'
      distribution = @store.createRecord 'distribution', {issue: issue}

      @set 'isDistributing', true

      distribution.save().then =>
        Ember.RSVP.all(@get('subscribers').mapBy('activeSubscription').map (subscription) =>
          fulfillment = @store.createRecord 'fulfillment', {issue: issue, subscription: subscription, distribution: distribution}
          fulfillment.save()
        ).then((fulfillments) ->
          fulfillments.map((fulfillment) ->
            distribution.get('fulfillments').pushObject fulfillment
            fulfillment.get('subscription').save()
          )
        ).then( ->
          issue.get('distributions').pushObject distribution
          issue.save()
        ).then( ->
          distribution.save()
        ).then =>
          @set 'isDistributing', false

`export default IssueDistributeController`
