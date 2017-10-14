require "spec_helper"

describe AuthApi::Engine do
  subject { described_class }

  it "has been isolated with a name" do
    expect(subject.isolated?).to be_truthy
    expect(subject.railtie_name).to eql "auth_api"
  end

  it "adds AuthApi::ControllerAdditions into ActionController::Base" do
    AuthApi.configuration.inherited_controller = ActionController::Base
    expect(AuthApi::SessionsController.new).to respond_to(:current_user)
  end

end
