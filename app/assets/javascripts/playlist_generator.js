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
    this.showLoadingAnimation();
    e.stopPropagation();
    e.preventDefault();
    var form = $(e.currentTarget);
    $('.error').hide();
    var val = form.find('#username').val();
    console.log(val);
    if (val.length == 0 || val == this.usernameStartText) {
      $('.error').text('Please enter your Songkick username');
      $('.error').show();
    }
    else {
      this.showLoadingAnimation();
      $.ajax({
        url: form.attr('action'),
        method: 'post',
        data: {
          username: val
        },
        complete: this.playlistLoaded.bind(this)
      });
    }
  },

  showLoadingAnimation: function() {
    $('#loading').show();
    $('#loading_songkick').addClass('animated_sk');
    $('#loading_spotify').addClass('animated_spotify');
  },

  usernameFocus: function(e) {
    if (!this.usernameChanged) {
      $('#username').removeClass('empty');
      $('#username').val('');
    }
  },

  usernameBlur: function(e) {
    if (!this.usernameChanged) {
      $('#username').addClass('empty');
      $('#username').val(this.usernameStartText);
    }
  },

  usernameChange: function(e) {
    var username = $.trim($('#username').val());
    this.usernameChanged = username != this.usernameStartText && username.length > 0;
    this.usernameBlur(e);
  },

  playlistLoaded: function(e) {
    $('#response').html(e.responseText);
    $('#response').show();
    $('#user-form').hide();
    $('#connect-to-songkick').hide();
    $('#loading').hide();
  }
};

$(function() {
  PlaylistGenerator.initialize();
});
