module Store
  class << self

    def store(obj, options={})
      File.open(db_filename,'w') do |file|
        file.write Marshal.dump(obj)
      end
      return obj
    end
    
    def load
      Marshal.load(File.read(db_filename))
    end

    private
    def db_filename
      File.join(ENV['HOME'], '.trackdb')
    end
  end
end
