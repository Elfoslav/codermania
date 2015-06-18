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

  #####################
  # General study group
  #####################
  generalStudyGroup = StudyGroups.findOne({ title: 'general' })
  elfoslav = Meteor.users.findOne({ username: 'elfoslav' })
  unless generalStudyGroup
    StudyGroups.insert
      title: 'general'
      topics: 'general discussion'
      isPublic: true
      userId: elfoslav?._id
      userIds:  [ elfoslav?._id ]
