require 'rubygems'
require 'bundler'

Bundler.setup

$LOAD_PATH  << File.expand_path(File.dirname(__FILE__) + '/lib')

require 'dm-core'
require 'dm-validations'
require 'dm-observer'
require 'open-uri'
require 'nokogiri'
gem     'twitter4r'
require 'twitter'
require 'chronic'

Dir.glob(File.join(File.dirname(__FILE__), 'lib/*.rb')).each {|f|require f }

database_path = File.expand_path(File.join(File.dirname(__FILE__), 'db', 'visits.db'))
DataMapper.setup(:default, "sqlite3://#{database_path}")
begin
  response = repository(:default).adapter.query("SELECT id FROM visits LIMIT 1")
rescue Exception => e
  Visit.auto_migrate!
end

twitter_config = YAML::load_file(File.dirname(__FILE__) + '/config/twitter_config.yml')
::TWITTER = Twitter::Client.new(twitter_config)

arrivals_page = ArrivalsPage.new('http://www.portoffelixstowe.co.uk/shipping/')
arrivals_page.each_arrival do |arrival|
  Visit.handle_arrival(arrival)
end

departures_page = DeparturesPage.new('http://www.portoffelixstowe.co.uk/shipping/frmSailingSchedule.aspx?historical=1')
departures_page.each_departure do |departure|
  Visit.handle_departure(departure)
end
