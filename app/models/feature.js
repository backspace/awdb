import Ember from 'ember';
import DS from 'ember-data';

var Feature = DS.Model.extend({
  title: DS.attr('string'),
  issue: DS.belongsTo('issue'),

  contributors: DS.hasMany('person'),

  appendNewContributor: function(id) {
    if (Ember.isPresent(id)) {
      this.store.find('person', id).then(function(result) {
        this.get('contributors').pushObject(result);
      }.bind(this));
    }
  },

  rev: DS.attr('string')
});

export default Feature;
