`import Ember from 'ember'`
`import DS from 'ember-data'`

Contribution = DS.Model.extend
  feature: DS.belongsTo 'feature'
  entity: DS.belongsTo 'entity'

  transaction: DS.belongsTo 'transaction'
  isUncompensated: Ember.computed.none 'transaction'

  # Wanted to use defaultValue but it didn't have access to this?
  setDefaultCompensation: Ember.on 'init', ->
    # FIXME should be injected
    settings = @container.lookup 'settings:main'

    @set('compensation', settings.get('featureCompensation')) unless @get('compensation')

  rev: DS.attr 'string'

`export default Contribution`
