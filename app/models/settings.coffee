`import Ember from 'ember'`
`import DS from 'ember-data'`

Ember.Inflector.inflector.uncountable 'settings'

Settings = DS.Model.extend
  featureCompensation: DS.attr 'number', {defaultValue: 100}

  subscriptionCanada3: DS.attr 'number', {defaultValue: 30}
  subscriptionUsa3: DS.attr 'number', {defaultValue: 35}
  subscriptionInternational3: DS.attr 'number', {defaultValue: 40}
  subscriptionInstitution3: DS.attr 'number', {defaultValue: 45}

  rev: DS.attr 'string'

`export default Settings`
