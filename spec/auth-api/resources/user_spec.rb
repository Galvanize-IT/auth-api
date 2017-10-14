require "spec_helper"

describe AuthApi::User do
  describe "initialize" do
    subject { described_class.new(id: "42", attributes: { foo: "bar", bar: nil }) }

    it "allows setting attributes from data" do
      expect(subject.attributes).to eq foo: "bar", bar: nil
      expect(subject.foo).to eq "bar"
      subject.bar = "baz"
      expect(subject.bar).to eq "baz"
    end

    it "can get an intersection of attributes when provided a list of attribute keys" do
      intersection = subject.attribute_intersection([:foo])
      expect(intersection).to eq foo: "bar"
    end

  end
end
