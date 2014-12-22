// Taken from https://gist.github.com/pwfisher/b4d27d984ad5868baab6

import Ember from 'ember';

export default Ember.Component.extend({
  tagName: 'input',
  type: 'radio',
  attributeBindings: [ 'checked', 'name', 'type', 'value' ],

  checked: function () {
    return this.get('value') === this.get('groupValue');
  }.property('value', 'groupValue'),

  change: function () {
    this.set('groupValue', this.get('value'));
  }
});
