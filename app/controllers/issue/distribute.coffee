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

      @set 'isDistributing', true

      Ember.RSVP.all(@get('subscribers').mapBy('activeSubscription').map (subscription) =>
        fulfillment = @store.createRecord 'fulfillment', {issue: issue, subscription: subscription}
        fulfillment.save()
      ).then((fulfillments) ->
        fulfillments.map((fulfillment) ->
          fulfillment.get('subscription').save()
        )
      ).then =>
        @set 'isDistributing', false

`export default IssueDistributeController`
