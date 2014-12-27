/* global require */
/* global waitForModels */

import Ember from 'ember';

import config from '../../config/environment';

// Thanks to rsutphin
// https://gist.github.com/rsutphin/73fdad14a24884eee336

export default function() {
  Ember.Test.registerAsyncHelper('waitForModels', function (app, typeNames) {
    // The context object is necessary because unregisterWaiter will unregister
    // _all_ bare function waiters if any bare function waiter is unregistered.
    // This appears to be due to a defect in Ember.compare (or maybe
    // unregisterWaiter shouldn't use Ember.compare).
    var context = Math.random();

    // console.log('waitForModels', typeNames.join(' | '));
    var anyPending = true;

    var maxIterations = 250;
    var iterations = 0;

    function pendingChecker() {
      var i, records, pending = false;
      var store = app.__container__.lookup('store:main');
      iterations++;

      for (i = 0 ; iterations < maxIterations && i < typeNames.length ; i++) {
        records = store.all(typeNames[i]);
        // console.log(typeNames[i], records.getEach('currentState.stateName').join(" | "));
        pending = records.isAny('isSaving') ||
          records.isAny('isEmpty') ||
          records.isAny('isLoading') ||
          records.isAny('isReloading');
        if (pending) { break; }
      }
      anyPending = pending;
    }

    var waiter = function () {
      if (anyPending) {
        Ember.run.next(null, pendingChecker);
        return false;
      } else {
        // console.log('done waiting for models');
        Ember.Test.unregisterWaiter(context, waiter);
        return true;
      }
    };

    Ember.Test.registerWaiter(context, waiter);

    return wait();
  });

  Ember.Test.registerAsyncHelper('waitForAllModels', function(app, typeNames) {
    // Find all model names from https://stackoverflow.com/questions/25124980/ember-js-get-all-model-names
    var modulePrefix = config.modulePrefix;
    var models = Object.keys(require._eak_seen).filter(function(module) {
      return module.indexOf(modulePrefix + '/models/') === 0;
    }).map(function(fullName) {
      var split = fullName.split('/');
      return split[split.length - 1];
    });

    return waitForModels(models);
  });
}
