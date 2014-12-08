import Ember from 'ember';
import DS from 'ember-data';

var Feature = DS.Model.extend({
  title: DS.attr('string'),
  issue: DS.belongsTo('issue'),

  contributors: DS.hasMany('person'),

  rev: DS.attr('string'),

  contributorNames: Ember.computed('contributors.@each.name', function() {
    return this.get('contributors').mapBy('name').join(", ");
  })
});

export default Feature;
