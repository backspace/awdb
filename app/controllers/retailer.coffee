`import Ember from 'ember'`
`import SetPropertyOnModelChange from '../mixins/set-property-on-model-change'`

RetailerController = Ember.ObjectController.extend SetPropertyOnModelChange,
  requestedEditing: false

  setPropertyOnModelChange:
    property: 'requestedEditing'
    value: false

  isEditing: Ember.computed.any 'model.isNew', 'requestedEditing'

  newSubscription: Ember.computed 'model.isRetailer', 'model.isNew', ->
    # TODO what is this 999
    # TODO should the default retail cost be set in the model?
    @store.createRecord 'subscription', {count: 999, cost: @settings.get('retailIssueCost')}

  actions:
    doneEditing: ->
      model = @get('model')
      if model.get('isNew')
        model.save().then =>
          @transitionToRoute 'retailer', model
      else
        model.save().then =>
          @set 'requestedEditing', false

    revertEditing: ->
      model = @get 'model'

      if model.get 'isNew'
        model.deleteRecord()
        @transitionToRoute 'retailers'
      else
        model.rollback()

      @set 'requestedEditing', false

    edit: ->
      @set 'requestedEditing', true

    subscribe: ->
      subscription = @get('newSubscription')
      subscription.set 'entity', @get('model')
      subscription.save().then =>
        @get('model').save()

    endSubscription: ->
      retailer = @get 'model'
      subscription = retailer.get 'activeSubscription'

      subscription.end()

    buildReturn: ->
      @transitionToRoute 'retailer.returns.new', @get('model')
      undefined

`export default RetailerController`
