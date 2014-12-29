import Ember from 'ember';

export default Ember.Mixin.create({
  watchForModelChange: Ember.observer('model.id', function() {
    var newID = this.get('model.id');

    if (newID !== this.oldID) {
      var settings = this.get('setPropertyOnModelChange');
      this.set(settings.property, settings.value);
      this.oldID = newID;
    }
  })
});
