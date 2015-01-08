/* global $ */
import Ember from 'ember';

// Adapted from http://css-tricks.com/moving-highlight/

export default Ember.Mixin.create({
  applyMovingHighlight: function() {
    var originalBG = this.$().css("background");
    var color = "#9999ff";

    this.$()
    .mousemove(function(e) {

        var x = e.offsetX;
        var y = e.offsetY;
        var xy = x + " " + y;

        var bgWebKit = "-webkit-gradient(radial, " + xy + ", 0, " + xy + ", 100, from(rgba(255,255,255,0.6)), to(rgba(255,255,255,0.0))), " + color;

        $(this).find('i, a')
          .css({ background: bgWebKit,"-webkit-background-clip": "text", "-webkit-text-fill-color": "transparent"})
          .addClass("followed");

    }).mouseleave(function() {
      $(this).find('i, a').css({ background: originalBG, "-webkit-background-clip": "initial", "-webkit-text-fill-color": "initial" });
      $(this).removeClass("followed");
    });
  }.on('didInsertElement')
});
