require 'spec_helper'

describe GitReporter do

  describe "#initialize" do
    it "make GitReporter instance" do
      GitReporter.new.kind_of?(GitReporter).should be_true
    end
  end

  describe "#fetch" do
    it "should get git repository's metadata" do
      git_reporter = GitReporter.new.fetch
      git_reporter.repository.class.should == Git
    end
  end

  describe "#format" do
  end

    describe "#report" do
    context "outputing on stdout" do
      it "print on console" do
      end
    end

    context "by sending mail" do
    end
  end

end
