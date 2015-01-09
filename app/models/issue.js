import Ember from 'ember';
import DS from 'ember-data';

var Issue = DS.Model.extend({
  title: DS.attr("string"),
  number: DS.attr('number'),
  features: DS.hasMany('feature'),
  mailouts: DS.hasMany('mailouts'),
  printings: DS.hasMany('printing'),
  returns: DS.hasMany('return'),

  persistedMailouts: Ember.computed.filterBy('mailouts', 'isNew', false),

  persistedPrintings: Ember.computed.filterBy('printings', 'isNew', false),
  printingsCopyCount: Ember.computed.mapBy('persistedPrintings', 'count'),
  printingsCopies: Ember.computed.sum('printingsCopyCount'),

  mailoutsCopyCount: Ember.computed.mapBy('mailouts', 'count'),
  mailoutsCopies: Ember.computed.sum('mailoutsCopyCount'),

  mailoutsRetailCopyCount: Ember.computed.mapBy('mailouts', 'retailCount'),
  mailoutsRetailCopies: Ember.computed.sum('mailoutsRetailCopyCount'),

  mailoutsUnreturnedRetailCopies: Ember.computed('mailoutsRetailCopies', 'returnsCopies', function() {
    return this.get('mailoutsRetailCopies') - this.get('returnsCopies');
  }),

  returnsCopyCount: Ember.computed.mapBy('returns', 'count'),
  returnsCopies: Ember.computed.sum('returnsCopyCount'),

  inStock: Ember.computed('printingsCopies', 'mailoutsCopies', 'returnsCopies', function() {
    return this.get('printingsCopies') - this.get('mailoutsCopies') + this.get('returnsCopies');
  }),

  rev: DS.attr("string")
});

export default Issue;
