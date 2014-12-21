`import Ember from 'ember'`
`import DS from 'ember-data'`

Ember.Inflector.inflector.uncountable 'settings'

Settings = DS.Model.extend
  featureCompensation: DS.attr 'number', {defaultValue: 100}

  rev: DS.attr 'string'

`export default Settings`
