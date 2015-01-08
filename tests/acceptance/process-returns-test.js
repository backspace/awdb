import Ember from 'ember';
import startApp from '../helpers/start-app';

import PouchTestHelper from '../helpers/pouch-test-helper';

var application = null;

describe("Acceptance: Process returns", function() {
  beforeEach(function(done) {
    application = startApp();

    andThen(() => {
      PouchTestHelper.buildStore(application, this.currentTest.title).then((store) => {
        Ember.run(() => {
          Ember.RSVP.hash({
            retailer: store.createRecord('entity', {name: 'Returner', isRetailer: true}).save(),
            issue: store.createRecord('issue', {title: 'Premier'}).save()
          }).then(() => {
            done();
          });
        });
      });
    });
  });

  afterEach((done) => {
    endAcceptanceTest(done);
  });

  describe("when a return is entered", function() {
    beforeEach(function(done) {
      this.timeout(5000);
      viewRetailer("Returner");

      click(".js-build-return");

      fillIn("input[name=count]", 30);

      andThen(() => {
        var issueID = find('select option:contains(Premier)').attr('value');
        fillIn("select", issueID);
      });

      click(".js-save");

      waitForModels(["entity", "return"]);

      andThen(() => {
        done();
      });
    });

    it("is listed on the retailer", (done) => {
      viewRetailer("Returner");

      andThen(() => {
        expectElement(".returns li:contains(Premier)", {contains: "30"});
        done();
      });
    });

    it("increases the stock of the issue", (done) => {
      // FIXME note that a return can be saved even when no issues have been sent
      viewIssue("Premier");

      andThen(() => {
        expectElement('.stock', {contains: '30 copies'});
        done();
      });
    });
  });
});
