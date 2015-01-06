import Ember from 'ember';
import DS from 'ember-data';

var Issue = DS.Model.extend({
  title: DS.attr("string"),
  number: DS.attr('number'),
  features: DS.hasMany('feature'),
  mailouts: DS.hasMany('mailouts'),
  printings: DS.hasMany('printing'),

  persistedMailouts: Ember.computed.filterBy('mailouts', 'isNew', false),

  persistedPrintings: Ember.computed.filterBy('printings', 'isNew', false),
  printingsCopyCount: Ember.computed.mapBy('persistedPrintings', 'count'),
  printingsCopies: Ember.computed.sum('printingsCopyCount'),

  mailoutsCopyCount: Ember.computed.mapBy('mailouts', 'count'),
  mailoutsCopies: Ember.computed.sum('mailoutsCopyCount'),

  inStock: Ember.computed('printingsCopies', 'mailoutsCopies', function() {
    return this.get('printingsCopies') - this.get('mailoutsCopies');
  }),

  rev: DS.attr("string")
});

export default Issue;
