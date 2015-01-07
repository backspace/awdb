`import Ember from 'ember'`

TransactionListItem = Ember.Component.extend
  tagName: 'tr'

  formattedAmount: Ember.computed 'transaction.amount', ->
    amount = @get 'transaction.amount'

    if @get 'isNegative'
      "-$#{Math.abs amount}"
    else
      "$#{amount}"

  isNegative: Ember.computed.lt 'transaction.amount', 0

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
