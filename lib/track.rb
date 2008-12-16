require 'date'

$:.unshift File.dirname(__FILE__)
require 'core_ext'
require 'track/store'
require 'track/entry'

class TrackError < StandardError; end

class Track
  attr_reader :options, :projects, :entries
  attr_writer :options

  def initialize
    @entries   = []
  end

  def options;   @options  ||= {} end
  def projects;  options['projects'] || {} end # must not be cached

  def ==(other)
    [self.options, self.entries] == [other.options, other.entries]
  end

  def run(argv, options=nil)
    self.options = options
    case argv.first
    when 'stop';      stop
    when 'cat';       cat
    when 'projects';  cat_projects
    when 'start';     start(*argv[1..-1])
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
    project = projects[project]

    if project.nil?
      raise TrackError, "Error: Project not found"
    end

    if description.empty?
      raise TrackError, "Error: Must enter a description"
    end

    stop
    description = description.join(' ')

    add_entry(project, description)
  end

  def stop
    return if entries.empty? || last_entry.stopped?
    last_entry.stop
  end

  # TODO: REFACTORBATE
  def cat
    entries_by_date = entries.group_by{|e| e.start_date}
    entries_by_date.each do |date, date_entries|
      $stdout.puts
      $stdout.puts date
      $stdout.puts '-' * date.to_s.size
      $stdout.puts(date_entries.map{|e|e.to_s}.join("\n"))
      entries_by_project = date_entries.group_by{|e| e.project}
      $stdout.puts
      $stdout.puts 'Totals:'
      $stdout.puts '======='
      entries_by_project.each do |project, project_entries|
        cat_total_times_by_project(project, project_entries)
      end
    end
  end

  def cat_projects
    $stdout.puts options['projects'].sort_by{|k,_|k}.map{|id,name| "#{id}:\t#{name}"}
  end

  private

  def cat_total_times_by_project(project, entries)
    total_seconds = entries.inject(0) { |sum, entry| sum += entry.duration_in_seconds if entry.stopped?; sum}
    minutes = total_seconds / 60.0
    hours, minutes = minutes.round.divmod(60)
    time_string = "%02d:%02d" % [hours, minutes]

    $stdout.puts "#{project}:\t#{time_string}"
  end

end
