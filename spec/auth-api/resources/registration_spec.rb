require "spec_helper"

describe AuthApi::Registration do
  describe "initialize" do
    subject { described_class.new(id: "42", attributes: { foo: "bar", bar: nil }) }

    it "allows setting attributes from data" do
      expect(subject.attributes).to eq foo: "bar", bar: nil
      expect(subject.foo).to eq "bar"
      subject.bar = "baz"
      expect(subject.bar).to eq "baz"
    end

  end
end
