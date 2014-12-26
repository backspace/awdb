`import Ember from 'ember'`

EntitiesIndexController = Ember.ArrayController.extend
  subscribers: Ember.computed.filterBy('model', 'isSubscribed')
  formerSubscribers: Ember.computed.filterBy('model', 'isFormerSubscriber')

  actions:
    labels: ->
      doc = new jsPDF()

      labelHeight = 30

      @get('model').forEach (entity, index) ->
        address = entity.get('address')
        address = "No address" if Ember.isNone(address)

        doc.text 20, (index + 1)*labelHeight + 1, "#{entity.get('name')}\n#{address}"

      $("body").append("<iframe>")
      $('iframe').attr('src', doc.output('datauristring')).height(352).width(396)

`export default EntitiesIndexController`
