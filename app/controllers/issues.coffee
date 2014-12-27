`import Ember from 'ember'`

IssuesController = Ember.ArrayController.extend
  sortProperties: ['number']
  sortAscending: true

  persistedIssues: Ember.computed.filterBy 'arrangedContent', 'isNew', false

`export default IssuesController`
