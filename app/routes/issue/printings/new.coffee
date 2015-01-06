`import Ember from 'ember'`

NewPrintingRoute = Ember.Route.extend
  model: (params) ->
    @store.createRecord 'printing', {issue: @modelFor('issue')}

`export default NewPrintingRoute`
