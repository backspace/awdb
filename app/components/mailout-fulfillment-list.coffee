`import Ember from 'ember'`

MailoutFulfillmentList = Ember.Component.extend
  tagName: 'ul'
  classNames: ['fa-ul', 'mailout-fulfillment-list']

  actions:
    deleteFulfillment: (fulfillment) ->
      @sendAction 'deleteFulfillment', fulfillment

`export default MailoutFulfillmentList`
