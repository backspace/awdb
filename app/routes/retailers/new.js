import Ember from 'ember';

export default Ember.Route.extend({
  controllerName: 'retailer',

  model: function() {
    return this.store.createRecord('entity', {isRetailer: true});
  },

  renderTemplate: function() {
    this.render('retailer', {into: 'application'});
  }
});
