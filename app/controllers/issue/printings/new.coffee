`import Ember from 'ember'`

NewPrintingController = Ember.Controller.extend
  printing: Ember.computed.alias 'model'

  actions:
    doneEditing: ->
      @get('printing').save().then =>
        @get('printing.issue').save().then =>
          @transitionToRoute 'issue.index', @get('printing.issue')

    revertEditing: ->
      issue = @get('printing.issue')
      @get('printing').deleteRecord().then =>
        @transitionToRoute 'issue.index', issue

`export default NewPrintingController`
