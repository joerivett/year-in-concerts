var PlaylistGenerator = {
  initialize: function() {
    $('#user-form').on('submit', this.formSubmit.bind(this));
  },

  formSubmit: function(e) {
    e.stopPropagation();
    e.preventDefault();
    var form = $(e.currentTarget);
    console.log(form);
    $.ajax({
      url: form.attr('action'),
      method: 'post',
      data: {
        username: form.find('#username').val()
      },
      complete: this.playlistLoaded.bind(this)
    });
  },

  playlistLoaded: function(e) {
    console.log(e);
  }
};

$(function() {
  PlaylistGenerator.initialize();
});
