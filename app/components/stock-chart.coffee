`import Ember from 'ember'`

StockChart = Ember.Component.extend
  classNames: ['stock-chart']

  axis:
    rotated: true
    x:
      show: false
    y:
      show: false

  legend:
    show: false

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

`export default StockChart`
