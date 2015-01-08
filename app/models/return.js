import DS from 'ember-data';

export default DS.Model.extend({
  entity: DS.belongsTo('entity'),
  count: DS.attr('number'),

  rev: DS.attr('string')
});
