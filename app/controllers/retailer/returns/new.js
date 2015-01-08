import Ember from 'ember';

export default Ember.Controller.extend({
  actions: {
    doneEditing() {
      this.get('model').save().then(() => {
        this.get('model.entity').save().then(() => {
          this.transitionToRoute('retailer', this.get('model.entity'));
        });
      });
    },

    revertEditing() {
      var retailer = this.get('model.entity');
      this.get('model').deleteRecord();
      this.transitionToRoute('retailer', retailer);
    }
  }
});
