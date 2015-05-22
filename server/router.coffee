###########
# Redirects
###########
Router.route '/how-to-learn-to-code-properly',
  where: 'server',
  action: ->
    console.log 'redirect /how-to-learn-to-code-properly'
    this.response.writeHead 301,
      Location: 'http://www.codermania.com/blog/how-to-learn-to-code-properly'
    this.response.end()

Router.route '/why-codermania',
  where: 'server',
  action: ->
    console.log 'redirect /why-codermania'
    this.response.writeHead 301,
      Location: 'http://www.codermania.com/blog/why-codermania'
    this.response.end()

Router.route '/why-javascript',
  where: 'server',
  action: ->
    console.log 'redirect /why-javascript'
    this.response.writeHead 301,
      Location: 'http://www.codermania.com/blog/why-javascript'
    this.response.end()

Router.route '/why-learn-to-code',
  where: 'server',
  action: ->
    console.log 'redirect /why-learn-to-code'
    this.response.writeHead 301,
      Location: 'http://www.codermania.com/blog/why-learn-to-code'
    this.response.end()
