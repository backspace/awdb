import Ember from 'ember';

export default Ember.Component.extend({
  alignAmounts: function() {
    var indexOfAmountColumn = this.$('th:contains(Amount)').index();

    this.$().alignColumn(indexOfAmountColumn, {center: '$'});
  }.on('didInsertElement')
});
