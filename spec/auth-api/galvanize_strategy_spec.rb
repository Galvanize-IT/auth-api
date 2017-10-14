require "spec_helper"

describe OmniAuth::Strategies::Galvanize do
  subject { described_class.new({}) }

  describe "#raw_info" do
    let(:response) { { data: { attributes: { uid: "42" } } } }
    let(:access_token) { double(get: nil) }

    before do
      allow(subject).to receive(:access_token).and_return(access_token)
    end

    it "returns the parsed response from the correct api endpoint" do
      allow(access_token).to receive(:get).with("/api/v1/me").and_return(double(parsed: response))
      expect(subject.raw_info).to eq response
    end

  end

  describe "content" do
    let(:raw_info) { { "data" => { "attributes" => { "uid" => "42" } } } }

    before do
      allow(subject).to receive(:raw_info).and_return(raw_info)
    end

    describe "#uid" do

      it "returns the id" do
        expect(subject.uid).to eq "42"
      end

    end

    describe "#info" do

      it "returns the data" do
        expect(subject.info).to eq "data" => { "attributes" => { "uid" => "42" } }
      end

    end
  end
end
