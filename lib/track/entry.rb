class Entry
  attr_accessor :start_time, :stop_time, :project, :description
  def initialize(start_time, stop_time, project, description)
    @start_time  = start_time
    @stop_time   = stop_time
    @project     = project
    @description = description
  end

  def duration_in_seconds
    return unless stopped?
    stop_time - start_time
  end

  def stopped?
    not stop_time.nil?
  end

  def stop
    @stop_time = Time.now
  end

  def to_s
    line = "[#{start_string} - #{stop_string}] "
    line << project if project
    line << ":\t" << description unless description.nil? || description.empty?
    line
  end

  def start_date
    Date.new(start_time.year, start_time.month, start_time.day)
  end

  def start_string
    time_string(start_time)
  end

  def stop_string
    if stop_time
      time_string(stop_time)
    else
      placeholder
    end
  end

  private

  def time_string(time = Time.now)
    time.strftime('%H:%M')
  end

  def placeholder
    "--:--"
  end
end
