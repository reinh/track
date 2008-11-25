require 'date'

$:.unshift File.dirname(__FILE__)
require 'track/store'
require 'track/entry'

class Track
  attr_reader :options, :projects, :entries
  attr_writer :options

  def initialize
    @entries   = []
  end

  def options;   @options  ||= {} end
  def projects;  @projects ||= options['projects'] || {} end

  def ==(other)
    [self.options, self.entries] == [other.options, other.entries]
  end

  def run(argv, options=nil)
    self.options = options
    case argv.first
    when 'stop' ; stop
    when 'cat'  ; cat
    else start(*argv)
    end
  end

  def log_filename
    str = options['filename'] || 'track'
    str += '-'
    str += Date.today.to_s
    str += '.txt'
    return str
  end

  def start(*args)
    stop
    project_name = args.shift
    description  = args.join(' ').strip
    project      = projects[project_name] || project_name

    write_line(project, description)
  end

  def stop
    return if entries.empty? || entries.last.stopped?
    entries.last.stop
  end

  def cat
    unless File.exists?(log_filename)
      $stderr.puts("No track file available")
      return Kernel.exit(1)
    end

    File.foreach(log_filename){ |line| $stdout.puts(line) }
  end

end
