`import Ember from 'ember'`

TransactionListItem = Ember.Component.extend
  tagName: 'tr'

  formattedAmount: Ember.computed 'transaction.amount', ->
    amount = @get 'transaction.amount'

    if amount < 0
      "-$#{Math.abs amount}"
    else
      "$#{amount}"

  eventType: Ember.computed 'transaction.event', ->
    event = @get 'transaction.event'

    if event
      constructor = event.constructor.toString()

      if constructor.contains "fulfillment"
        "Fulfillment"
      else if constructor.contains "contribution"
        "Contribution"
      else if constructor.contains "subscription"
        "Subscription"
      else if constructor.contains "printing"
        "Printing"

`export default TransactionListItem`
