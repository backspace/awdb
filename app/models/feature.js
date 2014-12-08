import DS from 'ember-data';

var Feature = DS.Model.extend({
  title: DS.attr('string'),
  issue: DS.belongsTo('issue'),

  contributors: DS.hasMany('person'),

  rev: DS.attr('string')
});

export default Feature;
