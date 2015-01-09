import DS from 'ember-data';

export default DS.Model.extend({
  entity: DS.belongsTo('entity'),
  issue: DS.belongsTo('issue'),
  returned: DS.attr('number'),
  sold: DS.attr('number'),

  rev: DS.attr('string')
});
