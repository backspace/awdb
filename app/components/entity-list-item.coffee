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

`export default EntityListItem`
