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
    $('.error').hide();

    var form = $(e.currentTarget);
    var val = form.find('#username').val();

    if (val.length == 0 || val == this.usernameStartText) {
      $('.error').text('Please enter your Songkick username');
      $('.error').show();
    }
    else {
      this.showLoadingAnimation();
      $('#user-form').hide();
      $.ajax({
        url: form.attr('action'),
        method: 'post',
        data: {
          username: val
        },
        success: this.playlistLoaded.bind(this),
        error: this.playlistError.bind(this)
      });

      this.sendEvent({'eventCategory': 'click', 'eventAction': 'lets_go'});
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

  playlistLoaded: function(responseText) {
    $('#response').html(responseText);
    $('#response').show();
    $('#connect-to-songkick').hide();
    $('#loading').hide();

    this.sendEvent({'eventCategory': 'playlist_generate', 'eventAction': 'success'});
  },

  playlistError: function(e) {
    $('#response').html(e.responseText);
    $('#response').show();
    $('#connect-to-songkick').show();
    $('#user-form').show();
    $('#loading').hide();

    this.sendEvent({'eventCategory': 'playlist_generate', 'eventAction': 'error', 'eventLabel': $.trim($('#response').text())});
  },

  sendEvent: function(fields) {
    if (typeof fields === "undefined") return;
    fields['hitType'] = 'event';
    ga('send', {
      eventCategory: fields['eventCategory'],
      eventAction: fields['eventAction'],
      eventLabel: fields['eventLabel']
    });
  }
};

$(function() {
  PlaylistGenerator.initialize();
});
