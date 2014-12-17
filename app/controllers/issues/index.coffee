`import Ember from 'ember'`

IssuesIndexController = Ember.ArrayController.extend
  sortProperties: ['number']
  sortAscending: true

`export default IssuesIndexController`
