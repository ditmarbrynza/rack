class TimeFormatter

  attr_reader :result

  CORRECT_FORMATS = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }

  def initialize(formats, time = nil)
    @formats = formats.split(",")
    @time = Time.now
    @success = false
    @valid_time_format = ["year", "month", "day", "hour", "minute", "second"]
    @unknown_time_format = []
  end

  def call
    @formats.each do |format|
      get_unknown_time_format(format)
    end

    @success = @unknown_time_format.empty?

    unless @success
      @result = ("Unknown time format #{@unknown_time_format}")
      return
    end

    output_format = make_output_format(@formats)
    @result = @time.strftime(output_format)
  end

  def success?
    @success
  end

  private

  def get_unknown_time_format(format)
    if !@valid_time_format.include?(format)
      @unknown_time_format << format
    end
  end


  def make_output_format(formats)
    result = ""
    @formats.each { |format|
      if CORRECT_FORMATS.include?(format)
        result << "-" unless result.empty?
        result << CORRECT_FORMATS[format]
      end
    }
    result
  end

end
