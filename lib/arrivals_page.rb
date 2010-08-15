require 'time_parser.rb'

class ArrivalsPage
  include TimeParser

  def initialize(url)
    @arrivals = Nokogiri::HTML(open(url))
  end
  
  def each_arrival
    @arrivals.xpath("//table[@class='Results']/tr[not(@class)]").each do |arrival_row|
      arrival_columns = arrival_row.css('td')
      image_tag =  arrival_columns[1].css('img').to_s
      arrived = image_tag.include?("I00") || image_tag.include?("IF0") || 
                image_tag.include?("I0N") || image_tag.include?("IM0")
      next unless arrived
      yield({ :vessel_name    => arrival_columns[2].content.strip,
              :arrival_time   => parse_time(arrival_columns[0].content.strip),
              :gross_tonnage  => arrival_columns[3].content,
              :overall_length => arrival_columns[4].content,
              :last_port      => arrival_columns[5].content.strip,
              :next_port      => arrival_columns[6].content.strip,
              :agent          => arrival_columns[7].content.strip })
    end
  end
end
