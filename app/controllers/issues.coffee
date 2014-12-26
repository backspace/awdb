`import Ember from 'ember'`

IssuesController = Ember.ArrayController.extend
  sortProperties: ['number']
  sortAscending: true

`export default IssuesController`
