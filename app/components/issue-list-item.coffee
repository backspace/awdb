`import Ember from 'ember'`

IssueListItem = Ember.Component.extend
  tagName: 'li'

  classNameBindings: ['active']
  active: false

`export default IssueListItem`
