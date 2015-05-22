Meteor.startup ->
  process.env.MAIL_URL = Meteor.settings.env.MAIL_URL

  ###############
  # Slides
  ###############
  slide = Slides.findOne({ lang: 'sk' })
  unless slide
    Slides.insert
      lang: 'sk'
      currentSlideNumber: 1
      currentSlideTemplate: 'skSlide1'
