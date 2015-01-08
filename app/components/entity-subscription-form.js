import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['entity-subscription-form'],

  isComplete: Ember.computed.and('subscription.cost', 'subscription.count'),
  isIncomplete: Ember.computed.not('isComplete'),

  saving: false,

  lookupSettings: function() {
    this.set('settings', this.container.lookup('settings:main'));
  }.on('init'),

  setDefaultCount: function() {
    if (this.get('saving')) { return; }

    var subscription = this.get('subscription');
    if (Ember.isNone(subscription.get('count'))) {
      subscription.set('count', '3');
    }
  }.observes('subscription', 'entity.id'),

  setCost: function() {
    if (this.get('saving')) { return; }

    var settings = this.get('settings');

    if (Ember.isNone(settings)) { return; }

    var subscription = this.get('subscription');
    var entity = this.get('entity');

    subscription.set('cost', settings.costForSubscription(subscription.get('count'), entity.get('classification')));
  }.observes('subscription.count', 'entity.classification', 'settings', 'entity.id'),

  onInit: function() {
    this.setDefaultCount();
  }.on('init'),

  actions: {
    save() {
      // TODO find a better way to stop changing subscription after save fired
      this.set('saving', true);
      this.sendAction('save', this.get('subscription'));
    }
  }
});
