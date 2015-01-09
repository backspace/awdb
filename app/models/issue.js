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

  // TODO Ember CPM to reduce these?

  printingsCopyCount: Ember.computed.mapBy('persistedPrintings', 'count'),
  printingsCopies: Ember.computed.sum('printingsCopyCount'),

  mailoutsCopyCount: Ember.computed.mapBy('mailouts', 'count'),
  mailoutsCopies: Ember.computed.sum('mailoutsCopyCount'),

  mailoutsRetailCopyCount: Ember.computed.mapBy('mailouts', 'retailCount'),
  mailoutsRetailCopies: Ember.computed.sum('mailoutsRetailCopyCount'),

  mailoutsUnknownRetailCopies: Ember.computed('mailoutsRetailCopies', 'returnsCopies', function() {
    return this.get('mailoutsRetailCopies') - this.get('returnsReturnedCopies') - this.get('returnsSoldCopies');
  }),

  returnsReturnedCopyCount: Ember.computed.mapBy('returns', 'returned'),
  returnsReturnedCopies: Ember.computed.sum('returnsReturnedCopyCount'),

  returnsSoldCopyCount: Ember.computed.mapBy('returns', 'sold'),
  returnsSoldCopies: Ember.computed.sum('returnsSoldCopyCount'),

  inStock: Ember.computed('printingsCopies', 'mailoutsCopies', 'returnsCopies', function() {
    return this.get('printingsCopies') - this.get('mailoutsCopies') + this.get('returnsReturnedCopies');
  }),

  rev: DS.attr("string")
});

export default Issue;
