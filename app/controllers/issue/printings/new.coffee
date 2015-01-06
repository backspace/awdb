`import Ember from 'ember'`

NewPrintingController = Ember.Controller.extend
  actions:
    doneEditing: ->
      @get('printing').save().then =>
        @get('printing.issue').save().then =>
          @transitionToRoute 'issue.index', @get('printing.issue')

    revertEditing: ->
      issue = @get('printing.issue')
      @get('printing').deleteRecord()
      @transitionToRoute 'issue.index', issue

    setPrinter: (printer) ->
      @set('printing.entity', printer)

`export default NewPrintingController`
