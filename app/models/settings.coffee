`import Ember from 'ember'`
`import DS from 'ember-data'`

Ember.Inflector.inflector.uncountable 'settings'

Settings = DS.Model.extend
  featureCompensation: DS.attr 'number', {defaultValue: 100}
  featureComplimentaryIssues: DS.attr 'number', {defaultValue: 2}

  subscriptionCanada3: DS.attr 'number', {defaultValue: 30}
  subscriptionUsa3: DS.attr 'number', {defaultValue: 35}
  subscriptionInternational3: DS.attr 'number', {defaultValue: 40}
  subscriptionInstitution3: DS.attr 'number', {defaultValue: 45}

  subscriptionCanada6: DS.attr 'number', {defaultValue: 50}
  subscriptionUsa6: DS.attr 'number', {defaultValue: 60}
  subscriptionInternational6: DS.attr 'number', {defaultValue: 70}
  subscriptionInstitution6: DS.attr 'number', {defaultValue: 80}

  retailIssueCost: DS.attr 'number', {defaultValue: 8}

  costForSubscription: (count, classification) ->
    return undefined unless count? && classification?
    @get("subscription#{classification.capitalize()}#{count}")

  rev: DS.attr 'string'

`export default Settings`
