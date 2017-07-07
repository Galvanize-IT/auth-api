require 'spec_helper'

describe AuthApi::Engine do
  subject { described_class }

  it "has been isolated with a name" do
    expect(subject.isolated?).to be(true)
    expect(subject.railtie_name).to eql('auth_api')
  end

  it "adds AuthApi::ControllerAdditions into ActionController::Base" do
    expect(ActionController::Base.new).to respond_to(:current_user)
  end

end
