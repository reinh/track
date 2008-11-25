require File.dirname(__FILE__) + '/spec_helper'

describe Track do
  before do
    @track = Track.new

    @time = Time.now
    @time.stub!(:now).and_return(@time)
    @time_string = @time.strftime('%H:%M')
  end

  def last_line
    $stdout.readlines.last.chomp
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

  describe "#start"

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
        @track.entries.last.should be_stopped
      end
    end
  end

  describe "#cat"
end

describe Track do
  before do
    @track = Track.new
  end

  describe "#log_filename"
end
