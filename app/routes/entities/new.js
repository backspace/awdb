import Ember from 'ember';

export default Ember.Route.extend({
  controllerName: 'entity',
  templateName: 'entity',

  model: function() {
    return this.store.createRecord('entity');
  },
});
