import DS from 'ember-data';

export default DS.Model.extend({
  entity: DS.belongsTo('entity'),
  issue: DS.belongsTo('issue'),
  count: DS.attr('number'),

  rev: DS.attr('string')
});
