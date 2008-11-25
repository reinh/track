require File.dirname(__FILE__) + '/../spec_helper'

describe Store do
  TMP_FILENAME = File.expand_path(File.join(File.dirname(__FILE__), '..', 'fixtures', 'trackdb.tmp'))

  before do
    Store.stub!(:db_filename).and_return(TMP_FILENAME)
    @track = Track.new

    @time = Time.now
  end

  after do
    File.unlink(TMP_FILENAME) if File.exists?(TMP_FILENAME)
  end

  describe "storing and loading an object" do
    it "should store and load the object" do
      Track::Store.store(@track)
      Track::Store.load.should == @track
    end
  end

  describe "opening a track from storage and adding an entry" do
    it "should store the modified track" do
      pending
    end
  end
end
