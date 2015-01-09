import Ember from 'ember';

export default Ember.Component.extend({
  data: function() {
    var remainingCounts = this.get('subscribers').mapBy('fulfillmentsRemaining').reduce(function(counts, remaining) {
      if (!counts[remaining]) {
        counts[remaining] = 0;
      }

      counts[remaining]++;

      return counts;
    }, {});

    var sortedKeys = Object.keys(remainingCounts).sort(function(a, b) { return parseInt(a) - parseInt(b); })
    var maxIssuesRemaining = sortedKeys[sortedKeys.length - 1];

    var columns = [];

    for (var i = maxIssuesRemaining; i > 0; i--) {
      columns.push([i, remainingCounts[i] || 0]);
    }

    return {
      columns: columns,
      type: 'bar'
    };
  }.property('subscribers.@each.fulfillmentsRemaining'),

  axis: {
    rotated: true
  }
});
