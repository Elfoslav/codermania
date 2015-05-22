Template.presentation.onRendered ->
  $('body').on('keyup', (evt) ->
    #arrow left
    if evt.keyCode is 37
      console.log 'arrow left'
      slide = Slides.findOne({ lang: 'sk' })
      Meteor.call('slideLeft', slide)
    #arrow right
    if evt.keyCode is 39
      console.log 'arrow right'
      slide = Slides.findOne({ lang: 'sk' })
      Meteor.call('slideRight', slide)
  )

Template.presentation.destroyed = ->
  $('body').off('keyup')

Template.presentation.helpers
  slideTemplate: ->
    slide = Slides.findOne({ lang: 'sk' })
    slide.currentSlideTemplate
  slide: ->
    Slides.findOne({ lang: 'sk' })

Template.presentation.events
  'submit .slide-number-form': (evt, tpl) ->
    evt.preventDefault()
    slideNumber = parseInt evt.target.slideNumber.value
    Meteor.call 'setSlideNumber', slideNumber, (err) ->
      console.log err if err
  'click .run-code': (evt, tpl) ->
    evt.preventDefault()
    alert('ahoj');
