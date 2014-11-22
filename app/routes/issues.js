import Ember from 'ember';

export default Ember.Route.extend({
  model: function() {
    return this.store.find('issue');
  },

  actions: {
    edit: function() {
      this.controllerFor('issue').set('isEditing', true);
    },

    doneEditing: function() {
      this.controllerFor('issue').set('isEditing', false);
      this.modelFor('issue').save();
    },

    createIssue: function() {
      this.send('edit');
      var newIssue = this.get('store').createRecord('issue');
      this.transitionTo('issue', newIssue.save());
    }
  }
});
