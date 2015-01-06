`import Ember from 'ember'`

IssuesController = Ember.ArrayController.extend
  sortProperties: ['number']
  sortAscending: true

  persistedIssues: Ember.computed.filterBy 'arrangedContent', 'isNew', false

  issueCopies: Ember.computed.mapBy 'model', 'printingsCopies'
  issueMaxCopies: Ember.computed.max 'issueCopies'

`export default IssuesController`
