module TimeParser
  
  def parse_time(time_string)
    date_and_time     = time_string.split(' ')
    date_componants   = date_and_time[0].split('/')
    date_and_time[0]  = date_componants[1] + '/' + date_componants[0] + '/' + date_componants[2]
    Chronic.parse(date_and_time.join(" "))
  end
end
