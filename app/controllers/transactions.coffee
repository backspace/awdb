`import Ember from 'ember'`

TransactionsController = Ember.ArrayController.extend
  sortProperties: ['createdAt']
  sortAscending: true

`export default TransactionsController`
