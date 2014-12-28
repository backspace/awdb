`import Ember from 'ember'`

DistributeRoute = Ember.Route.extend
  model: (params) ->
    # FIXME hack to ensure entities are loaded even upon refresh

    distribution = @store.createRecord 'distribution', {issue: @modelFor('issue')}

    Ember.RSVP.hash
      issue: @store.find 'issue', @paramsFor('issue').issue_id
      distribution: distribution
      entities: @store.find 'entity'

  actions:
    showDistribution: (distribution) ->
      @transitionTo 'issue.distribution', distribution

`export default DistributeRoute`
