import Ember from 'ember';

// Taken from https://stackoverflow.com/a/27085279/760389
export default function() {
  Ember.Test.registerAsyncHelper('waitForControllerWithPromise', function(app, controllerName) {
    return new Ember.Test.promise(function(resolve) {

      // inform the test framework that there is an async operation in progress,
      // so it shouldn't consider the test complete
      Ember.Test.adapter.asyncStart();

      // get a handle to the promise we want to wait on
      var controller = app.__container__.lookup('controller:' + controllerName);
      var promise = controller.get('promise');

      promise.then(function(){

        // wait until the afterRender queue to resolve this promise,
        // to give any side effects of the promise resolving a chance to
        // occur and settle
        Ember.run.schedule('afterRender', null, resolve);

        // inform the test framework that this async operation is complete
        Ember.Test.adapter.asyncEnd();
      });
    });
  });
}
