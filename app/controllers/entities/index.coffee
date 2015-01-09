`import Ember from 'ember'`

EntitiesIndexController = Ember.Controller.extend
  needs: ['entities']

  subscribers: Ember.computed.alias 'controllers.entities.subscribers'

  data: Ember.computed 'subscribers', ->
    classificationCounts = @get('subscribers').reduce (classificationCounts, subscriber) ->
      classification = subscriber.get('classification')
      classification ?= 'none'

      classificationCounts[classification] ?= 0
      classificationCounts[classification] += 1

      classificationCounts
    , {}

    columns = Ember.keys(classificationCounts).map (classification) ->
      [classification, classificationCounts[classification]]

    Ember.Object.create
      columns: columns
      type: 'donut'

  donut: Ember.computed ->
    Ember.Object.create
      title: "Subscriber types"

`export default EntitiesIndexController`
