import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    return Ember.RSVP.hash({
      ret: this.store.createRecord('return', {entity: this.modelFor('retailer')}),
      issues: this.store.find('issue')
    });
  },

  setupController(controller, model) {
    // Like in printings/new, RSVP.hash removes a pre-set retailer, must set here
    var ret = model.ret;
    ret.set('entity', this.modelFor('retailer'));

    controller.set('model', ret);
    controller.set('issues', model.issues.sortBy('number'));
  }
});
