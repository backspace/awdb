`import Ember from 'ember'`

StockChart = Ember.Component.extend
  classNames: ['stock-chart']

  axis: Ember.computed 'max', ->
    rotated: true
    x:
      show: false
    y:
      show: false
      max: @get('max')

  grid:
    focus:
      show: false

  legend:
    show: false

  tooltip: Ember.computed 'issue.inStock', ->
    contents: =>
      return "#{@get('issue.inStock')} in stock<br>#{@get('issue.mailoutsUnknownRetailCopies')} at retailers"

  data: Ember.computed 'issue.inStock', ->
    retailMailed = @get('issue.mailoutsUnknownRetailCopies')
    entityMailed = @get('issue.mailoutsCopies') - retailMailed

    {
      columns: [
        ['stock', @get('issue.inStock')]
        ['retail-mailed', retailMailed]
        ['entity-mailed', entityMailed]
      ]
      type: 'bar'
      groups: [['entity-mailed', 'retail-mailed', 'stock']]
      order: null
    }

  size: Ember.computed 'width', 'height', ->
    if @get('width') && @get('height')
      {
        width: @get('width')
        height: @get('height')
      }
    else
      {}

`export default StockChart`
