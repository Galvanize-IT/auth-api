require "spec_helper"

describe AuthApi::Configuration do
  subject { described_class }

  around(:each) do |example|
    original_client_id = subject.client_id
    original_client_secret = subject.client_secret
    original_user_finder = subject.user_finder || -> {}
    original_user_resolver = subject.user_resolver || -> {}

    example.run

    subject.client_id = original_client_id
    subject.client_secret = original_client_secret
    subject.define_user_finder(&original_user_finder)
    subject.define_user_resolver(&original_user_resolver)
  end

  it "allows setting client id and secret tokens" do
    subject.client_id = "_client_id_"
    expect(subject.client_id).to eq "_client_id_"

    subject.client_secret = "_client_secret_"
    expect(subject.client_secret).to eq "_client_secret_"
  end

  it "allows defining the user finder block" do
    expect { subject.define_user_finder }.to raise_error(AuthApi::NoBlockGiven)

    subject.define_user_finder { |uid| "_user_#{uid}_" }
    expect(subject.user_finder.call("abc123")).to eq "_user_abc123_"
  end

  it "allows defining the user resolver block" do
    expect { subject.define_user_resolver }.to raise_error(AuthApi::NoBlockGiven)

    subject.define_user_resolver { |auth| "_user_#{auth.keys.join('_')}_" }
    expect(subject.user_resolver.call(key1: "stuff", key2: "stuff")).to eq "_user_key1_key2_"
  end

end
