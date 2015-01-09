import DS from 'ember-data';

export default DS.Model.extend({
  entity: DS.belongsTo('entity'),
  issue: DS.belongsTo('issue'),
  returned: DS.attr('number'),
  sold: DS.attr('number'),

  rev: DS.attr('string'),

  createTransaction: function() {
    var returned = this.get('returned');
    var settings = this.settings;

    if (returned > 0 && settings) {
      var amount = -returned*settings.get('retailIssueCost');
      var transaction = this.store.createRecord('transaction', {amount: amount, entity: this.get('entity'), 'return': this});
      transaction.save();
    }
  }.on('didCreate')
});
