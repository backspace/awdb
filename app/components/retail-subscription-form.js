import Ember from 'ember';

export default Ember.Component.extend({
  isComplete: Ember.computed.and('subscription.copies', 'subscription.cost'),
  isIncomplete: Ember.computed.not('isComplete'),

  actions: {
    save() {
      this.sendAction('save');
    }
  }
});
