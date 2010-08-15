require 'rubygems'
require 'bundler'

Bundler.setup

require 'dm-core'
require 'dm-observer'
require 'open-uri'
require 'nokogiri'
require 'chronic'
require 'twitter'

$LOAD_PATH  << File.expand_path(File.dirname(__FILE__) + '/lib')

Dir.glob(File.join(File.dirname(__FILE__), 'lib/*.rb')).each { |f| require f }


# database setup
# ==============
database_path = File.expand_path(File.join(File.dirname(__FILE__), 'db', 'visits.db'))
DataMapper.setup(:default, "sqlite3://#{database_path}")
begin
  response = repository(:default).adapter.query("SELECT id FROM visits LIMIT 1")
rescue Exception => e
  Visit.auto_migrate!
end


# twitter setup
# =============
config = ConfigStore.new(File.dirname(__FILE__) + '/config/twitter_config.yml')

oauth = Twitter::OAuth.new(config['consumer_token'], config['consumer_secret'])
oauth.authorize_from_access(config['access_token'], config['access_secret'])

::TWITTER = Twitter::Base.new(oauth)


# parse pages
# ===========
arrivals_page = ArrivalsPage.new('http://www.portoffelixstowe.co.uk/shipping/')
arrivals_page.each_arrival do |arrival|
  Visit.handle_arrival(arrival)
end

departures_page = DeparturesPage.new('http://www.portoffelixstowe.co.uk/shipping/frmSailingSchedule.aspx?historical=1')
departures_page.each_departure do |departure|
  Visit.handle_departure(departure)
end

