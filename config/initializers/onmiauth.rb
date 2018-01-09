require 'rspotify/oauth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, "828d01e912c44fb18882398677505b34", "3d38cba4bab349f19077ad97fd0bb5ab", scope: 'user-read-email playlist-modify-public'
end
