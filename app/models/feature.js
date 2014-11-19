import DS from 'ember-data';

import Issue from '../models/issue';

var Feature = DS.Model.extend({
  title: DS.attr('string'),
  issue: DS.belongsTo('issue'),

  rev: DS.attr('string')
});

export default Feature;
