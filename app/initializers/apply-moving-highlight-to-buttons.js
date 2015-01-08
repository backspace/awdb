/* global $ */
import Ember from 'ember';

// Adapted from http://css-tricks.com/moving-highlight/

var alreadyRun = false;

export default {
  name: 'apply-moving-highlight-to-buttons',
  initialize() {
    if (alreadyRun) {
      return;
    }
    else {
      alreadyRun = true;
    }

    Ember.View.reopen({
      applyMovingHighlightToButtons: function() {
        this.$("button")
        .mouseenter(function() {
          var originalBG = $(this).data('originalBG');

          if (!originalBG) {
            originalBG = $(this).css('background');
            $(this).data('originalBG', originalBG);
          }
        })
        .mousemove(function(e) {
            var originalBG = $(this).data('originalBG');

            var x = e.offsetX;
            var y = e.offsetY;
            var xy = x + " " + y;

            var bgWebKit = "-webkit-gradient(radial, " + xy + ", 0, " + xy + ", 100, from(rgba(255,255,255,0.2)), to(rgba(255,255,255,0.0))), " + originalBG;

            $(this)
              .css({ background: bgWebKit})
              .addClass("followed");

        }).mouseleave(function() {
          var originalBG = $(this).data('originalBG');

          if (originalBG) {
            $(this).css({ background: originalBG});
          }

          $(this).removeClass("followed");
        });
      }.on('didInsertElement')
    });
  }
};
