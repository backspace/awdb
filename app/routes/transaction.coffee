`import Ember from 'ember'`

TransactionRoute = Ember.Route.extend
  controllerName: 'transactions'
  templateName: 'transactions'

  model: (params) ->
    # TODO make a proper single transaction view
    Ember.RSVP.all([@store.find('transaction', params.transaction_id)])

`export default TransactionRoute`
