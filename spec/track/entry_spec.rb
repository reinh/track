require File.dirname(__FILE__) + '/../spec_helper'

describe Entry do

  describe "#stopped?" do
    it "should be false if the entry is not yet stopped" do
      Entry.new(Time.now, nil, "Project", "description").stopped?.should be_false
    end
  end

  describe "#stop" do
    it "should stop the entry" do
      started_entry = Entry.new(Time.now, nil, "Project", "description")
      started_entry.stop
      started_entry.should be_stopped
    end
  end
  describe "#to_s" do
    before do
      @time = Time.now
      @entry = Entry.new(@time, nil, "Project", "Description")
    end

    it "includes the start time" do
      @entry.to_s.should include(@entry.start_string)
    end

    it "includes a placeholder for the end time" do
      @entry.to_s.should include('--:--')
    end

    it "wraps the times in []" do
      @entry.to_s.should match(/\[.+\]/)
    end

    it "includes the project name followed by a \":\"" do
      @entry.to_s.should include("Project:")
    end

    it "includes the description" do
      @entry.to_s.should include("Description")
    end

    describe "with project \"Project\" and description \"Description\"" do
      it "looks like \"[<time> - --:--] Project:	Description\"" do
        @entry.to_s.should == "[#{@entry.start_string} - --:--] Project:\tDescription"
      end
    end
  end
end
