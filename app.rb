class App

  def call(env)
    @env = env
    @status = 404
    @valid_time_format = ["year", "month", "day", "hour", "minute", "second"]
    @unknown_time_format = []
    @body = start
    [status, headers, @body]
  end

  private

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def start
    if valid_request?
      set_status(200)
      get_time
    else 
      error
    end
  end

  def valid_request?
    @env['REQUEST_PATH'] == '/time' && @env['REQUEST_METHOD'] == 'GET'
  end

  def get_time
    query_string = Rack::Utils.parse_nested_query(@env['QUERY_STRING'])
    return error if !query_string['format']

    formats = query_string['format'].split(",")
    puts "formats: #{formats}"

    formats.each do |format|
      get_unknown_time_format(format)
    end

    if !@unknown_time_format.empty?
      set_status(400)
      return ["Unknown time format #{@unknown_time_format}\n"] 
    end

    output_format = make_output_format(formats)
    time = Time.now.strftime(output_format)
    ["#{time}\n"]
  end

  def get_unknown_time_format(format)
    if !@valid_time_format.include?(format)
      @unknown_time_format << format
    end
  end

  def set_status(status)
    @status = status
  end

  def status
    @status
  end

  def error
    ["Error\n"]
  end

  def make_output_format(formats)
    output_format = ""
    sort_format = get_sort_format(formats)

    if !sort_format.empty?
      output_format << "%Y" if sort_format.include?("year")
      if sort_format.include?("month") && !output_format.empty?
        output_format << "-%m" 
      elsif sort_format.include?("month") && output_format.empty?
        output_format << "%m"
      end
      if sort_format.include?("day") && !output_format.empty?
        output_format << "-%d" 
      elsif sort_format.include?("day") && output_format.empty?
        output_format << "%d"
      end
      output_format << " " if !output_format.empty?
      output_format << "%H" if sort_format.include?("hour")
      if sort_format.include?("minute") && !output_format.empty?
        output_format << ":%M" 
      elsif sort_format.include?("minute") && output_format.empty?
        output_format << "%M"
      end
      if sort_format.include?("second") && !output_format.empty?
        output_format << ":%S" 
      elsif sort_format.include?("second") && output_format.empty?
        output_format << "%S"
      end
    end
      
    output_format
  end

  def get_sort_format(formats)
    sort_format = []
    formats.each do |format|
      case format
      when "year"
        sort_format << format
      when "month"
        sort_format << format
      when "day"
        sort_format << format
      when "hour"
        sort_format << format
      when "minute"
        sort_format << format
      when "second"
        sort_format << format
      end
    end
    sort_format
  end

end