class DeparturesPage
  include TimeParser

  def initialize(url)
    @departures = Nokogiri::HTML(open(url))
  end
  
  def each_departure
    @departures.xpath("//table[@class='Results']/tr[not(@class)]").each do |departure_row|
      departure_columns = departure_row.css('td')
      departure_time = parse_time(departure_columns[0].content.strip)
      next if departure_time < Time.now - 3600
      yield({ :vessel_name    => departure_columns[2].content.strip,
              :departure_time => departure_time,
              :gross_tonnage  => departure_columns[3].content,
              :overall_length => departure_columns[4].content,
              :last_port      => departure_columns[5].content.strip,
              :next_port      => departure_columns[6].content.strip,
              :agent          => departure_columns[7].content.strip })
    end
  end
end

