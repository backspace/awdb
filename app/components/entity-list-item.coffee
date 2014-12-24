`import Ember from 'ember'`

EntityListItem = Ember.Component.extend
  tagName: 'li'

  icon: Ember.computed 'entity.isRetailer', 'entity.isInstitution', ->
    entity = @get 'entity'

    if entity.get('isRetailer')
      'shopping-cart'
    else if entity.get('isInstitution')
      'institution'
    else
      'user'

`export default EntityListItem`
