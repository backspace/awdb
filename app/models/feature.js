import Ember from 'ember';
import DS from 'ember-data';

var Feature = DS.Model.extend({
  title: DS.attr('string'),
  issue: DS.belongsTo('issue'),

  contributors: Ember.computed.mapBy('contributions', 'entity'),
  contributions: DS.hasMany('contribution'),
  uncompensatedContributions: Ember.computed.filterBy('contributions', 'isUncompensated'),

  appendNewContributor: function(id) {
    if (Ember.isPresent(id)) {
      this.store.find('entity', id).then(function(result) {
        var contribution = this.store.createRecord('contribution', {entity: result, feature: this});
        this.get('contributions').pushObject(contribution);
      }.bind(this));
    }
  },

  removeContribution: function(contribution) {
    this.get('contributions').removeObject(contribution);

    if (contribution.get('isNew')) {
      contribution.destroyRecord().then(function() {
        this.save();
      }.bind(this));
    }
  },

  rev: DS.attr('string')
});

export default Feature;
