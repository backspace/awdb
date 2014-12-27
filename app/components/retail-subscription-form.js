import Ember from 'ember';

export default Ember.Component.extend({
  isComplete: Ember.computed.and('subscription.copies', 'subscription.cost'),
  isIncomplete: Ember.computed.not('isComplete'),

  isPersisted: Ember.computed.not('subscription.isNew'),

  actions: {
    save() {
      this.sendAction('save');
    },

    end() {
      this.sendAction('end');
    }
  }
});
