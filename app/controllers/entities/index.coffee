`import Ember from 'ember'`

EntitiesIndexController = Ember.Controller.extend
  needs: ['entities']

  subscribers: Ember.computed.alias 'controllers.entities.subscribers'

`export default EntitiesIndexController`
