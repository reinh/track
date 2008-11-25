module Store
  class << self

    def store(obj, options={})
      File.open(db_filename,'w') do |file|
        file.write Marshal.dump(obj)
      end
      return obj
    end

    def load
      if File.size?(db_filename)
        Marshal.load(File.read(db_filename))
      else
        Track.new
      end
    end

    def open
      track = load
      yield track
      store track
    end

    private
    def db_filename
      File.join(ENV['HOME'], '.trackdb')
    end
  end
end
