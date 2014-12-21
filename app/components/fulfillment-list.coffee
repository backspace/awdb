`import Ember from 'ember'`

FulfillmentList = Ember.Component.extend
  tagName: 'ul'

  actions:
    deleteFulfillment: (fulfillment) ->
      @sendAction 'deleteFulfillment', fulfillment

`export default FulfillmentList`
