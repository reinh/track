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

  def last_entry
    entries.last
  end
  
  def add_entry(project, description=nil)
    entry = Entry.new(Time.now, nil, project, description)
    entries << entry
    entry
  end

  def start(project, *description)
    stop
    description = description.join(' ')
    project = projects[project] || project
    add_entry(project, description)
  end

  def stop
    return if entries.empty? || last_entry.stopped?
    last_entry.stop
  end

  def cat
    $stdout.puts(entries.map{|e|e.to_s}.join("\n"))
  end

end
