import Ember from 'ember';
import DS from 'ember-data';

var Issue = DS.Model.extend({
  title: DS.attr("string"),
  number: DS.attr('number'),
  features: DS.hasMany('feature'),
  distributions: DS.hasMany('distributions'),
  printings: DS.hasMany('printing'),

  persistedDistributions: Ember.computed.filterBy('distributions', 'isNew', false),

  rev: DS.attr("string")
});

export default Issue;
