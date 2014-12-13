import Ember from 'ember';
import registerAcceptanceTestHelpers from './201-created/register-acceptance-test-helpers';
import Application from '../../app';
import Router from '../../router';
import config from '../../config/environment';

export default function startApp(attrs) {
  var App;

  var attributes = Ember.merge({}, config.APP);
  attributes = Ember.merge(attributes, attrs); // use defaults, but you can override;

  Router.reopen({
    location: 'none'
  });

  Ember.run(function() {
    App = Application.create(attributes);
    App.setupForTesting();
    registerAcceptanceTestHelpers();

    // Taken from https://stackoverflow.com/a/27085279/760389
    // TODO store somewhere better if it survives
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

    App.injectTestHelpers();
  });

  App.reset(); // this shouldn't be needed, i want to be able to "start an app at a specific URL"

  return App;
}
