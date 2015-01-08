`import Ember from 'ember'`
`import MovingHighlight from '../mixins/apply-moving-highlight'`

IssueListItem = Ember.Component.extend MovingHighlight,
  tagName: 'li'

  classNameBindings: ['active']
  active: false

`export default IssueListItem`
