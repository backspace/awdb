`import Ember from 'ember'`

EntityListItem = Ember.Component.extend
  tagName: 'li'

  classNameBindings: ['active', 'warning']
  active: false
  warning: false

  attributeBindings: ['warningTitle:title']

  warningTitle: Ember.computed 'warning', ->
    if @get 'warning'
      @get 'warningText'

  name: Ember.computed 'entity.name', 'nameOverride', ->
    override = @get('nameOverride')

    if override? then override else @get('entity.name')

  icon: Ember.computed 'entity.isRetailer', 'entity.isInstitution', ->
    entity = @get 'entity'

    return 'question' unless entity?

    if entity.get('isRetailer')
      'shopping-cart'
    else if entity.get('isInstitution')
      'institution'
    else
      'user'

  route: Ember.computed 'entity.isRetailer', ->
    if @get('entity.isRetailer')
      'retailer'
    else
      'entity'

  listItemIcon: Ember.computed.none 'inlineIcon'

  # Experimenting with moving highlight:
  # http://css-tricks.com/moving-highlight/

  setEasterEgg: Ember.on 'init', ->
    unless $('h2').data('egg')
      $('h2').click =>
        cookie = @get('cookie')

        currentValue = cookie.getCookie 'easter-egg'
        newValue = if currentValue == 'true' then 'false' else 'true'
        cookie.setCookie('easter-egg', newValue)

        document.location.reload()
      .data('egg', true)

  addHighlight: Ember.on 'didInsertElement', ->
    return unless @get('cookie')?.getCookie('easter-egg') == 'true'
    `
    var originalBG = $(".list a").css("background");
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
    `
    true

  addButtonNonsense: Ember.on 'didInsertElement', ->
    return unless @get('cookie')?.getCookie('easter-egg') == 'true'
    `

    $("button")
    .mouseenter(function(e) {
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
    `
    true

`export default EntityListItem`
