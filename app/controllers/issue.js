import Ember from 'ember';

export default Ember.ObjectController.extend({
  isEditing: false,

  newFeature: Ember.computed('', function(key, value) {
    var newFeature = this.store.createRecord('feature');

    if (arguments.length > 1) {
      newFeature = value;
    }

    return newFeature;
  }),

  actions: {
    saveFeature: function(context) {
      var promise = context.promise;
      var feature = context.feature;

      if (feature.get('isNew')) {
        var issue = this.get('model');

        feature.set('issue', issue);
        feature.save().then(function() {
          this.set('newFeature', this.store.createRecord('feature'));

          issue.get('features').pushObject(feature);
          issue.save().then(function() {
            promise.resolve();
          });
        }.bind(this));
      }
      else {
        feature.save().then(function() {
          promise.resolve();
        });
      }

      return promise;
    }
  }
});
