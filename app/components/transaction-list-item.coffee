`import Ember from 'ember'`

TransactionListItem = Ember.Component.extend
  tagName: 'tr'

  formattedAmount: Ember.computed 'transaction.amount', ->
    amount = @get 'transaction.amount'

    if amount < 0
      "-$#{Math.abs amount}"
    else
      "$#{amount}"

`export default TransactionListItem`
