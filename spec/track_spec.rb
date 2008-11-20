require File.dirname(__FILE__) + '/spec_helper'

describe Track do
  TMP_FILENAME = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', 'time_log.tmp'))

  before do
    @track = Track.new
    @track.stub!(:log_filename).and_return(TMP_FILENAME)

    @time = Time.now
    @time.stub!(:now).and_return(@time)
    @time_string = @time.strftime('%H:%M')
  end

  after do
    File.unlink(TMP_FILENAME) if File.exists?(TMP_FILENAME)
  end

  def line_count
    `wc -l #{TMP_FILENAME} 2>/dev/null`.to_i
  end
  private :line_count

  def last_line
    File.readlines(TMP_FILENAME).last.chomp
  end

  describe "#run" do
    describe "when the first argument is \"stop\"" do
      it "stops" do
        @track.should_receive(:stop)
        @track.run(["stop"])
      end
    end

    describe "when the first argument is not stop" do
      it "starts" do
        @track.should_receive(:start)
        @track.run(["tm"])
      end

      it "passes the arguments to start" do
        @track.should_receive(:start).with(:one, :two)
        @track.run([:one, :two])
      end
    end
  end

  describe "#start" do
    it "stops any started task" do
      @track.should_receive(:stop)
      @track.send(:start)
    end

    it "appends a line to the log file" do
      lambda do
        @track.send(:start, "Project", "Description")
      end.should change{line_count}
    end

  end

  describe "#write_line" do
    before do
      @track.send(:write_line, "Project", "Description")
    end

    it "includes the start time" do
      last_line.should include(@time_string)
    end

    it "includes a placeholder for the end time" do
      last_line.should include('--:--')
    end

    it "wraps the times in []" do
      last_line.should match(/\[.+\]/)
    end

    it "includes the project name followed by a \":\"" do
      last_line.should include("Project:")
    end

    it "includes the description" do
      last_line.should include("Project:")
    end

    describe "with project \"Project\" and description \"Description\"" do
      it "looks like \"[<time> - --:--] Project:	Description\"" do
        last_line.should == "[#{@time_string} - --:--] Project:\tDescription"
      end
    end
  end

  describe "#stop" do
    it "replaced the end time placeholder with the end time" do
      @track.send(:start)
      @track.send(:stop)
      last_line.should_not include('--:--')
      last_line.should include("[#@time_string - #@time_string]")
    end

    it "does not change the last line if there is nothing to stop" do
      @track.send(:start)
      @track.send(:stop)
      lambda {@track.send(:stop)}.should_not change{last_line}
    end
  end

  describe "#cat" do
    it "should open the log file for reading" do
      @track.send(:start) # ensure the file exists
      File.should_receive(:open).with(@track.send(:log_filename))
      @track.send(:cat)
    end

    it "should output each line in the file to STDOUT" do
      @track.send(:start) # ensure the file exists
      line_count = File.readlines(@track.send(:log_filename)).size
      STDOUT.should_receive(:puts).exactly(line_count).times
      @track.send(:cat)
    end

    describe "if no log file is available" do
      it "should exit with status 1" do
        lambda{@track.send(:cat)}.should raise_error(SystemExit)
      end

      it "should not execute the remainder of the method" do
        # weak sauce for testing the implementation. better ideas welcome.
        Kernel.stub!(:exit)
        File.should_not_receive(:open)
        @track.send(:cat)
      end
    end
  end
end

describe Track do
  before do
    @track = Track.new
  end

  describe "#log_filename" do
    it "starts with the filename specified in the options" do
      @track.options['filename'] = 'file'
      @track.send(:log_filename).should match(/^file/)
    end

    it "includes the current date" do
      require 'date'
      @track.send(:log_filename).should include(Date.today.to_s)
    end

    it "is a text file" do
      @track.send(:log_filename).should match(/\.txt$/)
    end

  end
end
