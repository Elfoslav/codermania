// filtering only HTTP request sent by seo via AJAX-Crawling
// this is meteorhacks:pickers coolest feature
var seoPicker = Picker.filter(function(req, res) {
  return /_escaped_fragment_/.test(req.url);
});

// route for the home page
seoPicker.route('/', function(params, req, res) {
  var html = SSR.render('index', {
    template: "main"
  });

  res.end(html);
});