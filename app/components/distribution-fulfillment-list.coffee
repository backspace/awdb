`import Ember from 'ember'`

DistributionFulfillmentList = Ember.Component.extend
  tagName: 'ul'
  classNames: ['fa-ul', 'distribution-fulfillment-list']

  actions:
    deleteFulfillment: (fulfillment) ->
      @sendAction 'deleteFulfillment', fulfillment

`export default DistributionFulfillmentList`
