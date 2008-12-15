module Store
  class << self

    def store(obj, options={})
      File.open(db_filename,'w') do |file|
        file.write Marshal.dump(obj)
      end
      return obj
    end

    def load
      track = nil
      if File.size?(db_filename)
        track = Marshal.load(File.read(db_filename)) rescue nil
      end
      track ||= Track.new
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
