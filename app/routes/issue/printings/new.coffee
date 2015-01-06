`import Ember from 'ember'`

NewPrintingRoute = Ember.Route.extend
  model: (params) ->
    Ember.RSVP.hash
      printing: @store.createRecord 'printing'
      entities: @store.find 'entity'

  setupController: (controller, model) ->
    # Putting the printing in RSVP.hash inexplicably strips away the issue
    printing = model.printing
    printing.set 'issue', @modelFor('issue')

    controller.set 'printing', printing
    controller.set 'entities', model.entities

`export default NewPrintingRoute`
