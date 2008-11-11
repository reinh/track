require 'date'

class Track
  attr_reader :options, :projects
  def initialize(options={})
    @options = options
    @projects = @options['projects'] || {}
  end

  def run(argv)
    argv.first == "stop" ? stop : start(*argv)
  end

  private

  def start(*args)
    stop
    project_name = args.shift
    description  = args.join(' ').strip
    project      = projects[project_name] || project_name

    write_line(project, description)
  end

  def stop
    return unless File.size?(log_filename)
    File.open(log_filename, 'r+') do |file|
      lines = file.readlines
      lines.last.sub!(placeholder, time_string)
      file.rewind
      file.write(lines.join)
    end
  end
  
  def write_line(project, description)
    line = "* [#{time_string} - #{placeholder}] "
    line << project if project
    line << ":\t" << description unless description.empty?
    File.open(log_filename, 'a') do |file|
      file.puts(line)
    end
  end

  def time_string(time = Time.now)
    time.strftime('%H:%M')
  end

  def log_filename
    str = options['filename'] || 'track'
    str += '-'
    str += Date.today.to_s
    str += '.textile'
    return str
  end

  def placeholder
    "--:--"
  end
end