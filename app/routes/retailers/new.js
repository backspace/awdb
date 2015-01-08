import Ember from 'ember';

export default Ember.Route.extend({
  controllerName: 'retailer.index',
  templateName: 'retailer.index',

  model: function() {
    return this.store.createRecord('entity', {isRetailer: true});
  },
});
