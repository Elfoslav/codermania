SSR.compileTemplate('index', Assets.getText('templates/index.html'));
// Blaze does not allow to render templates with DOCTYPE in it.
// This is a trick to made it possible
Template.index.helpers({
  getDocType: function() {
    return "<!DOCTYPE html>";
  },

  _: function(text) {
    return text;
  }
});

SSR.compileTemplate('main', Assets.getText('templates/main.html'));

Template.main.helpers({
  _: function(text) {
    return text;
  }
});