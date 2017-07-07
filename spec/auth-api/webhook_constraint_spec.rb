require 'spec_helper'

describe AuthApi::WebhookConstraint do
  before do
    allow(AuthApi.configuration).to receive(:webhook_token).and_return('_webhook_token_')
  end

  it "only matches when the X-Auth-Token header matches the configured value" do
    request = double(headers: {'X-Auth-Token' => '_webhook_token_'})
    expect(described_class.matches?(request)).to be_truthy

    request = double(headers: {'X-Auth-Token' => '_not_webhook_token_'})
    expect(described_class.matches?(request)).to be_falsey
  end

end

