require "date_time_helpers"

class Visit
  include DataMapper::Resource
  include Merb::Helpers::DateAndTime
  
  property  :id,                Serial
  property  :vessel_name,       String,           :nullable => false
  property  :arrival_time,      DateTime
  property  :departure_time,    DateTime
  property  :gross_tonnage,     Integer
  property  :overall_length,    Integer
  property  :last_port,         String
  property  :next_port,         String
  property  :agent,             String
  
  def self.handle_arrival(attributes)
    visit = Visit.first(:vessel_name  => attributes[:vessel_name])
    if visit
      visit.update_attributes(attributes)
    else
      visit = Visit.create(attributes)
    end
    visit
  end
  
  def self.handle_departure(attributes)
    visit = Visit.first(:vessel_name  => attributes[:vessel_name])
    return unless visit
    visit.attributes = attributes
    visit.destroy
  end
  
  def arrival_tweet
    "#{formatted_time(arrival_time)}: #{vessel_name} (#{thousands_separator(gross_tonnage)} GT, #{overall_length}m) arrived from #{last_port}"
  end
  
  def departure_tweet
    "#{formatted_time(departure_time)}: #{vessel_name} departed for #{next_port} after spending #{time_lost_in_words(arrival_time, departure_time)} in port"
  end
  
private
  
  def formatted_time(time)
    time.strftime("%a %b %d @ %H:%M")
  end
  
  def thousands_separator(number)
    number.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
  end
end
