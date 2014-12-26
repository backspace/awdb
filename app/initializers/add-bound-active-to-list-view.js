import Ember from 'ember';

// Taken from https://github.com/rwjblue/Ghost/blob/3a912bd89e6bd5270c9d919456bdb9c13622e2b5/core/client/utils/link-view.js

export function initialize() {
  Ember.LinkView.reopen({
    active: Ember.computed('resolvedParams', 'routeArgs', function () {
      var isActive = this._super();
      Ember.set(this, 'boundActive', isActive);
      return isActive;
    })
  });
}

export default {
  name: 'add-bound-active-to-list-view',
  initialize: initialize
};
