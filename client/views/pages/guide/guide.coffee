renderDefaultConnections = ->
  $('.common-path-web').connections
    to: '#back-end-heading, #front-end-heading, #full-stack-heading'

Template.guide.onRendered ->
  renderDefaultConnections()

  if window.scrollY > 100
    $('html, body').animate({
      scrollTop: $("#page-title").offset().top
    }, 300);

  $(window).on 'resize', ->
    $('connection').remove()
    renderDefaultConnections()

Template.guide.destroyed = ->
  $(window).off('resize')

Template.guide.helpers
  shareData: ->
    title: 'Ultimate guide for web developer'

Template.guide.events
  'click .choose-your-path a': (evt) ->
    a = evt.currentTarget
    $('connection').remove()
    if a.href.indexOf('path-of-front-end-developer') != -1
      $("#guide-root").text('Path of front-end developer')
      $('.common-path-web').connections
        to: '.front-end-path'
    if a.href.indexOf('path-of-full-stack-javascript-developer') != -1
      $("#guide-root").text('Path of full-stack JavaScript developer')
      $('.common-path-web').connections
        to: '#full-stack-heading, .databases-path, .ui-frameworks, .css-preprocessors,' +
          ' .javascript-preprocessors'
    if a.href.indexOf('path-of-back-end-javascript-developer') != -1
      $("#guide-root").text('Path of back-end JavaScript developer')
      $('.common-path-web').connections
        to: '.back-end-path-javascript, .databases-path'
    if a.href.indexOf('path-of-back-end-php-developer') != -1
      $("#guide-root").text('Path of back-end PHP developer')
      $('.common-path-web').connections
        to: '.back-end-path-php, .databases-path'
    if a.href.indexOf('path-of-back-end-ruby-developer') != -1
      $("#guide-root").text('Path of back-end Ruby developer')
      $('.common-path-web').connections
        to: '.back-end-path-ruby, .databases-path'
    if a.href.indexOf('path-of-back-end-python-developer') != -1
      $("#guide-root").text('Path of back-end Python developer')
      $('.common-path-web').connections
        to: '.back-end-path-python, .databases-path'
