`import Ember from 'ember'`

EntityListItem = Ember.Component.extend
  tagName: 'li'

  classNameBindings: ['active']
  active: false

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

`export default EntityListItem`
