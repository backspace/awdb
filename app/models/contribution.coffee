`import Ember from 'ember'`
`import DS from 'ember-data'`

Contribution = DS.Model.extend
  feature: DS.belongsTo 'feature'
  person: DS.belongsTo 'person'

  # Wanted to use defaultValue but it didn't have access to this?
  setDefaultCompensation: Ember.on 'init', ->
    # FIXME should be able to access injected settings
    @set('compensation', @container.lookup('settings:main').get('featureCompensation')) unless @get('compensation')

  rev: DS.attr 'string'

`export default Contribution`
