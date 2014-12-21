`import Ember from 'ember'`

TransactionsRoute = Ember.Route.extend
  model: ->
    window.tr = @
    @store.find 'transaction'

`export default TransactionsRoute`
