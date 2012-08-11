require "spec_helper"

describe Git do
  describe "BIN" do
    it "should set binary path" do
      expect(::Git::BIN).to match(/git/)      
    end
  end

  describe "#initialize" do
  end

  describe "#fetch" do
  end

  describe "#pull" do
  end

  describe "#log" do
    git = Git.new

    it "should get history of git repository" do
      expect(git.log).to be_a_kind_of(String)
    end
  end

  describe "#parse_log" do
    git = Git.new
    it "should return blob objects" do
      expect(git.blobs).to eq([])
      git.parse_log(git.log)
      expect(git.blobs).to be_a_kind_of(Array)
    end 
  end

end
