`import Ember from 'ember'`

NewPrintingRoute = Ember.Route.extend
  model: (params) ->
    Ember.RSVP.hash
      printings: @store.find 'printing'
      printing: @store.createRecord 'printing'
      entities: @store.find 'entity'

  setupController: (controller, model) ->
    # Putting the printing in RSVP.hash inexplicably strips away the issue
    printing = model.printing
    printing.set 'issue', @modelFor('issue')

    # Suggest previously-used printer
    previousPrintings = model.printings.filterBy('isNew', false)
    previousPrinter = previousPrintings.sortBy('createdAt').get('lastObject.entity')
    printing.set 'entity', previousPrinter

    controller.set 'printing', printing
    controller.set 'entities', model.entities

`export default NewPrintingRoute`
