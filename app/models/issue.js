import DS from 'ember-data';

var Issue = DS.Model.extend({
  title: DS.attr("string"),
  number: DS.attr('number'),
  features: DS.hasMany('feature'),

  rev: DS.attr("string")
});

export default Issue;
