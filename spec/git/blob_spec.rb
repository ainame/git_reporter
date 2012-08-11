require "spec_helper"

describe Git::Blob do
  describe "#initialize" do
    context "when are given an argument value as hash" do
      let(:argument) {
        {
          :commit => "2e4a850884dadfd1cc21baaba2fe29547193ab13", 
          :author => "Satoshi Namai <hogehoge@hoge.jp>",
          :date =>  DateTime.parse("Sun Jul 15 22:01:22 2012 + 0900"), 
          :message =>  "\nadd convinient guardfile\n\n"
        }
      }
      let(:blob){Git::Blob.new(argument)}
      
      it "have member variable" do
        expect(blob.date).to eq(argument[:date])
        expect(blob.commit).to eq(argument[:commit])
        expect(blob.author).to eq argument[:author]
        expect(blob.message).to eq argument[:message]
      end
    end
  end
end

describe Git::Blob::Extractor do
  describe "#parse" do
    let(:extractor) { Git::Blob::Extractor.new }

    context "when given commit line" do
      line = "commit 7671b3857fb7876ca7b95b5216157232a2efda79"

      it "should return commit(sha1 hash)" do
        expect(extractor.parse(line)).to eq([:commit, line.split[1]])
        expect(extractor.state).to eq(:commit)
      end
    end

    context "when given author line" do
      line = "Author: Satoshi Namai <ainame954@facebook.com>"

      it "should return author name" do
        expect(extractor.parse(line)).to eq([:author, line.split(' ', 2)[1]])
        expect(extractor.state).to eq(:author)
      end
    end

    context "when given date line" do
      line = "Date:   Sun Jul 15 22:01:09 2012 +0900"
      
      it "should return date string" do
        expect(extractor.parse(line)).to eq([:date, line.split(' ', 2)[1]])
        expect(extractor.state).to eq(:date)
      end
    end

    context "when given diff line" do
      line = "diff --git a/Gemfile b/Gemfile"
      
      it "should set :diff to @state" do
        extractor.parse(line) 
        expect(extractor.state).to eq(:diff)
      end
    end

    context "when given line that having space at head" do
      line = " commit: 23u748937...."
      
      it "should return nil" do
        expect(extractor.parse(line)).to eq(nil)
      end
    end

    context "when given diff line after header line" do
      date_line = "Date:   Sun Jul 15 22:01:09 2012 +0900"
      message_line = "\n    add hoge file\n\n"

      before do
        extractor.parse(date_line)
      end

      it "should change state from :state_header to :state_body" do
        expect{ 
          extractor.parse(message_line)
        }.to change{ extractor.state }.from(:date).to(:message)
      end
    end
  end
end

