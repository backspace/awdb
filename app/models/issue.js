import Ember from 'ember';
import DS from 'ember-data';

import sumBy from 'ember-cpm/macros/sum-by';

var Issue = DS.Model.extend({
  title: DS.attr("string"),
  number: DS.attr('number'),
  features: DS.hasMany('feature'),
  mailouts: DS.hasMany('mailouts'),
  printings: DS.hasMany('printing'),
  returns: DS.hasMany('return'),

  persistedMailouts: Ember.computed.filterBy('mailouts', 'isNew', false),

  persistedPrintings: Ember.computed.filterBy('printings', 'isNew', false),

  printingsCopies: sumBy('persistedPrintings', 'count'),
  mailoutsCopies: sumBy('mailouts', 'count'),
  mailoutsRetailCopies: sumBy('mailouts', 'retailCount'),

  mailoutsUnknownRetailCopies: Ember.computed('mailoutsRetailCopies', 'returnsCopies', function() {
    return this.get('mailoutsRetailCopies') - this.get('returnsReturnedCopies') - this.get('returnsSoldCopies');
  }),

  returnsReturnedCopies: sumBy('returns', 'returned'),
  returnsSoldCopies: sumBy('returns', 'sold'),

  inStock: Ember.computed('printingsCopies', 'mailoutsCopies', 'returnsCopies', function() {
    return this.get('printingsCopies') - this.get('mailoutsCopies') + this.get('returnsReturnedCopies');
  }),

  rev: DS.attr("string")
});

export default Issue;
