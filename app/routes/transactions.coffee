`import Ember from 'ember'`

TransactionsRoute = Ember.Route.extend
  model: ->
    @store.find 'transaction'

`export default TransactionsRoute`
