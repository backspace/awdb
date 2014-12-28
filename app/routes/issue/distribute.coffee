`import Ember from 'ember'`

DistributeRoute = Ember.Route.extend
  model: ->
    @store.createRecord 'distribution', {issue: @modelFor('issue')}

  setupController: (controller, model) ->
    controller.addSuggestedFulfillmentsToDistribution(model)
    controller.set 'model', model

  actions:
    showDistribution: (distribution) ->
      @transitionTo 'issue.distribution', distribution

`export default DistributeRoute`
