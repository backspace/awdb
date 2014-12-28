`import Ember from 'ember'`

DistributionRoute = Ember.Route.extend
  model: (params) ->
    @store.find('distribution', params.distribution_id)

`export default DistributionRoute`
