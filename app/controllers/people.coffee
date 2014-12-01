`import Ember from 'ember'`

PeopleController = Ember.ArrayController.extend
  actions:
    labels: ->
      doc = new jsPDF()

      @get('model').forEach (person, index) ->
        doc.text 20, (index + 1)*20 + 1, person.get('name')

      $("body").append("<iframe>")
      $('iframe').attr('src', doc.output('datauristring'))

`export default PeopleController`
