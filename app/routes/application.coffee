`import Ember from 'ember'`

# FIXME remove this hack, load fulfillments async

ApplicationRoute = Ember.Route.extend
  model: ->
    @store.find 'fulfillment'

`export default ApplicationRoute`
