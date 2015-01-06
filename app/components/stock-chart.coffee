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

  legend:
    show: false

  tooltip: Ember.computed 'issue.inStock', ->
    contents: =>
      return "#{@get('issue.inStock')} in stock"

  data: Ember.computed 'issue.inStock', ->
    {
      columns: [
        ['stock', @get('issue.inStock')]
        ['mailed', @get('issue.mailoutsCopies')]
      ]
      type: 'bar'
      groups: [['mailed', 'stock']]
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
