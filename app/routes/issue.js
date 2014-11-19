import Ember from 'ember';

export default Ember.Route.extend({
  model: function(params) {
    // FIXME why this one weird hack?
    var issue = this.store.find('issue', params.issue_id);

    var features = this.store.find('feature');

    return features.then(function() {
      return issue;
    });
  }
});
