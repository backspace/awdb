`import Ember from 'ember'`
`import SetPropertyOnModelChange from '../mixins/set-property-on-model-change'`

EntitySubscriptionList = Ember.Component.extend SetPropertyOnModelChange,
  subscriptionsSort: ['createdAt:desc']
  subscriptions: Ember.computed.sort 'entity.subscriptions', 'subscriptionsSort'

  # TODO broaden mixin to watch arbitrary paths
  model: Ember.computed.alias 'entity'

  setPropertyOnModelChange:
    property: 'requestedSubscriptionForm'
    value: false

  requestedSubscriptionForm: false

  showSubscriptionForm: Ember.computed.or 'entity.isNotSubscribed', 'requestedSubscriptionForm'

  actions:
    requestSubscriptionForm: ->
      @set 'requestedSubscriptionForm', true

    save: ->
      @sendAction 'save'
      @set 'requestedSubscriptionForm', false

`export default EntitySubscriptionList`
