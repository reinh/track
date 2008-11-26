require File.dirname(__FILE__) + '/spec_helper'

describe Track do
  before do
    @track = Track.new

    @time = Time.now
    @time.stub!(:now).and_return(@time)
    @time_string = @time.strftime('%H:%M')
  end

  describe "#==" do
    it "should be equal if the options are equal and the entries are equal" do
      @track = Track.new
      @track.options[:foo] = :foo
      @track.entries << :foo
      @track2 = Track.new
      @track2.options[:foo] = :foo
      @track2.entries << :foo
      @track.should == @track2
    end
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

  describe "#last_entry" do
    it "should return the last entry" do
      entry = @track.add_entry('project')
      @track.last_entry.should == entry
    end
  end

  describe "#add_entry" do
    it "should add a new entry" do
      lambda{@track.add_entry('project', 'description')}.should change(@track.entries, :size)
    end

    it "should return the new entry" do
      @track.add_entry('project', 'description').should == @track.last_entry
    end

    it "should set the entry's start time to now" do
      time = Time.now
      Time.stub!(:now).and_return(time)
      @track.add_entry('project', 'description').start_time.should == time
    end

    it "does not require a description" do
      lambda{@track.add_entry('project')}.should_not raise_error
    end
  end

  describe "#start" do
    it "should stop any started entry" do
      @track.should_receive(:stop)
      @track.start('project')
    end

    it "should create an new entry" do
      lambda{@track.start('project')}.should change(@track.entries, :size)
    end

    it "should map a project shortname" do
      expected =  "Test Project"
      @track.projects['test'] = expected
      @track.start('test')
      @track.last_entry.project.should == expected
    end

    it "should use the given project if it is not a shortname" do
      expected = 'test'
      @track.start(expected)
      @track.last_entry.project.should == expected
    end

    it "should concatenate multiple description arguments" do
      actual = %w(tacos are teh awesum)
      expected = 'tacos are teh awesum'
      @track.start('test', actual)
      @track.last_entry.description.should == expected
    end
  end

  describe "#stop" do
    before do
      @track = Track.new
    end

    describe "without any entries" do
      it "should not change the entries" do
        expected = @track.entries.dup
        @track.stop
        actual = @track.entries

        actual.should == expected
      end
    end

    describe "with a stopped entry" do
      before do
        @stopped_entry = Entry.new(Time.now, Time.now, '', '')
        @track.entries << @stopped_entry
      end

      it "should not change the entries" do
        expected = @track.entries.dup
        @track.stop
        actual = @track.entries

        actual.should == expected
      end
    end

    describe "with a started entry" do
      before do
        @started_entry = Entry.new(Time.now, nil, '', '')
        @track.entries << @started_entry
      end

      it "should stop the entry" do
        @track.stop
        @track.last_entry.should be_stopped
      end
    end
  end

  describe "#cat" do
    it "should output each entry as a string on a line to stdout" do
      old, $stdout = $stdout, StringIO.new
      @track.add_entry('project')
      @track.cat
      $stdout.rewind
      $stdout.read.should == @track.last_entry.to_s + "\n"
      $stdout = old
    end
  end
end

describe Track do
  before do
    @track = Track.new
  end

  describe "#log_filename"
end
