require 'rubygems'
require 'bundler'

Bundler.setup

require 'twitter'

oauth = Twitter::OAuth.new('consumer token', 'consumer secret')
oauth.authorize_from_access('access token', 'access secret')

client = Twitter::Base.new(oauth)
client.update('Heeeyyyyoooo from Twitter Gem!')

