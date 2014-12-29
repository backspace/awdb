/* jshint expr:true */
import Ember from 'ember';
import SetPropertyOnModelChangeMixin from 'awdb/mixins/set-property-on-model-change';

describe('SetPropertyOnModelChangeMixin', function() {
  // Replace this with your real tests.
  it('sets the property to the given value when the model changes', function() {
    var SetPropertyOnModelChangeObject = Ember.Object.extend(SetPropertyOnModelChangeMixin, {
      setPropertyOnModelChange: {property: 'isEditing', value: false},

      isEditing: false,

        model: null
    });

    var subject = SetPropertyOnModelChangeObject.create();
    expect(subject).to.be.ok;

    var firstModel = Ember.Object.create({id: 'something'});
    subject.set('isEditing', true);

    var secondModel = Ember.Object.create({id: 'another'});
    subject.set('model', secondModel);

    expect(subject.get('isEditing')).to.equal(false);
  });
});
