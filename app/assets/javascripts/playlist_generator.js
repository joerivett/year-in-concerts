var PlaylistGenerator = {
  usernameChanged: false,
  usernameStartText: '',

  initialize: function() {
    this.usernameStartText = $('#username').val();
    $('#user-form').on('submit', this.formSubmit.bind(this));
    $('#username').on('focus', this.usernameFocus.bind(this));
    $('#username').on('blur', this.usernameBlur.bind(this));
    $('#username').on('change', this.usernameChange.bind(this));
  },

  formSubmit: function(e) {
    e.stopPropagation();
    e.preventDefault();
    var form = $(e.currentTarget);
    $.ajax({
      url: form.attr('action'),
      method: 'post',
      data: {
        username: form.find('#username').val()
      },
      complete: this.playlistLoaded.bind(this)
    });
  },

  usernameFocus: function(e) {
    if (!this.usernameChanged) {
      $('#username').removeClass('empty');
    }
  },

  usernameBlur: function(e) {
    if (!this.usernameChanged) {
      $('#username').addClass('empty');
    }
  },

  usernameChange: function(e) {
    this.usernameChange = this.usernameStartText == $.trim($('#username').val());
    this.usernameBlur(e);
  },

  playlistLoaded: function(e) {
    $('#response').html(e.responseText);
  }
};

$(function() {
  PlaylistGenerator.initialize();
});
