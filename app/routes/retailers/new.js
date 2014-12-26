import Ember from 'ember';

export default Ember.Route.extend({
  controllerName: 'retailer',
  templateName: 'retailer',

  model: function() {
    return this.store.createRecord('entity', {isRetailer: true});
  },
});
