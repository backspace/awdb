import Ember from 'ember';

export default Ember.Route.extend({
  controllerName: 'issue.index',
  templateName: 'issue.index',

  model: function() {
    var issues = this.modelFor('issues');
    var latestIssue = issues.sortBy('number').get('lastObject');

    var nextIssueNumber = latestIssue ? latestIssue.get('number') + 1 : 1;

    return this.store.createRecord('issue', {number: nextIssueNumber});
  }
});
