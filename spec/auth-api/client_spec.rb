require 'spec_helper'

describe AuthApi::Client do
  subject { described_class.new(scope) }
  let(:scope) { '' }

  describe "interface" do
    let(:base_url) { AuthApi.configuration.url }
    let(:api_endpoint) { base_url + AuthApi::Client::API_ENDPOINT }

    before do
      stub_request(:post, base_url + '/api/oauth/token').to_return(
        body: '{"access_token":"_access_token_"}'
      )
    end

    it "allows making a post request" do
      stub_request(:post, api_endpoint + 'foo').with(
        body: '{"foo":"bar"}',
        headers: {'X-Foo' => 'bar', 'Authorization' => 'Bearer _access_token_'}
      )

      subject.post('foo', {foo: 'bar'}, {'X-Foo' => 'bar'})
    end

    it "can make a put/patch request" do
      stub_request(:put, api_endpoint + 'foo').with(
        body: '{"foo":"bar"}',
        headers: {'X-Foo' => 'bar', 'Authorization' => 'Bearer _access_token_'}
      )

      subject.patch('foo', {foo: 'bar'}, {'X-Foo' => 'bar'})
    end

    it "can make a delete request" do
      stub_request(:delete, api_endpoint + 'foo?foo=bar').with(
        headers: {'X-Foo' => 'bar', 'Authorization' => 'Bearer _access_token_'}
      )

      subject.delete('foo', {foo: 'bar'}, {'X-Foo' => 'bar'})
    end

    it "can make a get request" do
      stub_request(:get, api_endpoint + 'foo?foo=bar').with(
        headers: {'X-Foo' => 'bar', 'Authorization' => 'Bearer _access_token_'}
      )

      subject.get('foo', {foo: 'bar'}, {'X-Foo' => 'bar'})
    end

    it "allows making a raw request without using one of the built in methods" do
      stub_request(:put, api_endpoint + 'foo').with(
        body: '{"foo":"bar"}',
        headers: {'X-Foo' => 'bar', 'Authorization' => 'Bearer _access_token_'}
      )

      subject.request(:put, URI.parse(api_endpoint + 'foo'), {'X-Foo' => 'bar'}) do |request|
        request.body = {foo: 'bar'}.to_json
        subject.handle_response_for(request)
      end
    end

    it "raises an exception on authorization failure" do
      stub_request(:post, base_url + '/api/oauth/token').to_return(status: 401)

      expect{ subject.get('foo') }.to raise_error(AuthApi::UnableToAuthenticate)
    end

    it "raises an exception if the response isn't a success response" do
      stub_request(:post, api_endpoint + 'foo').to_return(status: 422)

      expect{ subject.post('foo') }.to raise_error(AuthApi::RequestFailed)
    end

  end

  describe "products" do
    let(:scope) { 'product.read' }

    it "can be loaded", :vcr do
      product = subject.product_details(uid: 'abc123')
      expect(product).to be_an_instance_of AuthApi::Product
      expect(product.name).to eq 'Web Development'
      expect(product.attributes[:name]).to eq 'Web Development'

      expect{ subject.product_details }.to raise_error(AuthApi::InvalidOptions)
    end

  end

  describe "users" do
    let(:scope) { 'user.read' }

    it "can be loaded", :vcr do
      user = subject.user_details(uid: '003V000000VLPZCIA5')
      expect(user).to be_an_instance_of AuthApi::User
      expect(user.first_name).to eq 'Dev'
      expect(user.attributes[:first_name]).to eq 'Dev'

      expect(user.products.length).to eq 2
      expect(user.registrations.length).to eq 2

      expect(user.products[0]).to be_an_instance_of AuthApi::Product
      expect(user.products[0].name).to eq 'Web Development'
      expect(user.products[0].label).to eq '17-04-WD-PHX'
      expect{ user.products[0].foo }.to raise_error NoMethodError
    end

  end
end
