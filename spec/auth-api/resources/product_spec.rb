require "spec_helper"

describe AuthApi::Product do
  subject { described_class.new(id: "42", attributes: { foo: "bar", bar: nil }) }

  describe "initialize" do

    it "allows setting attributes from data" do
      expect(subject.attributes).to eq foo: "bar", bar: nil
      expect(subject.foo).to eq "bar"
      subject.bar = "baz"
      expect(subject.bar).to eq "baz"
    end

  end

  describe "#attribute_intersection" do

    it "provides attributes that intersect with active record attributes" do
      mock = double(attributes: {foo: "baz", "bar" => :foo})
      expect(subject.attribute_intersection(mock)).to eq foo: "bar", bar: nil
    end

    it "can map using methods and not just attributes" do
      expect(subject).to receive(:cohort_name).and_return "_cohort_name_"
      expect(subject.attribute_intersection(cohort_name: nil)).to eq cohort_name: "_cohort_name_"
    end

    it "allows custom mapping of attributes that intersect" do
      expect(subject).to receive(:cohort_name).and_return "_cohort_name_"
      expect(subject.attribute_intersection([:baz, :zip], baz: :foo, zip: :cohort_name)).to eq baz: "bar",
        zip: "_cohort_name_"
    end

  end
end
