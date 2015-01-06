import Ember from 'ember';
import DS from 'ember-data';

var Issue = DS.Model.extend({
  title: DS.attr("string"),
  number: DS.attr('number'),
  features: DS.hasMany('feature'),
  mailouts: DS.hasMany('mailouts'),
  printings: DS.hasMany('printing'),

  persistedMailouts: Ember.computed.filterBy('mailouts', 'isNew', false),

  rev: DS.attr("string")
});

export default Issue;
