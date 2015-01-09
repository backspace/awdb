import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['issues-remaining-chart'],

  remainingCounts: function() {
    var remainingCounts = this.get('subscribers').mapBy('fulfillmentsRemaining').reduce(function(counts, remaining) {
      if (!counts[remaining]) {
        counts[remaining] = 0;
      }

      counts[remaining]++;

      return counts;
    }, {});

    return remainingCounts;
  }.property('subscribers.@each.fulfillmentsRemaining'),

  maxIssuesRemaining: function() {
    var remainingCounts = this.get('remainingCounts');

    var sortedKeys = Object.keys(remainingCounts).sort(function(a, b) { return parseInt(a) - parseInt(b); })
    var maxIssuesRemaining = sortedKeys[sortedKeys.length - 1];

    return maxIssuesRemaining;
  }.property('remainingCounts'),

  columnData: function() {
    var remainingCounts = this.get('remainingCounts');
    var maxIssuesRemaining = this.get('maxIssuesRemaining');

    var column = [];

    for (var i = 0; i <= maxIssuesRemaining; i++) {
      column.push(remainingCounts[i] || 0);
    }

    return column;
  }.property('remainingCounts'),

  data: function() {
    var column = this.get('columnData');
    column.unshift('data1');

    return {
      columns: [column],
      type: 'bar'
    };
  }.property('subscribers.@each.fulfillmentsRemaining'),

  maxNumberOfSubscribers: Ember.computed.max('columnData'),

  axis: function() {
    var maxSubscriberCount = this.get('maxNumberOfSubscribers');

    var ticks = [];

    for (var i = 0; i <= maxSubscriberCount; i++) {
      ticks.push(i);
    }

    return {
      rotated: true,
      x: {
        // FIXME why is this not working?
        label: 'Issues remaining',
        type: 'category'
      },
      y: {
        label: 'Number of subscribers',
        tick: {
          values: ticks
        }
      }
    }
  }.property('maxIssuesRemaining'),

  legend: {
    show: false
  },

  tooltip: {
    show: false
  },

  bar: {
    width: {
      // TODO why not 1?
      ratio: 0.95
    }
  }
});
