import DS from 'ember-data';

var Issue = DS.Model.extend({
  title: DS.attr("string"),
  rev: DS.attr("string")
});

export default Issue;
