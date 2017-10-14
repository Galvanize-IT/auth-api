require "spec_helper"

class MockController < ActionController::Base
  include AuthApi::ControllerAdditions

  def session
    { user_uid: "abc123" }
  end
end

describe AuthApi::ControllerAdditions do
  subject { MockController.new }

  describe "#current_user" do
    before do
      allow(AuthApi.configuration).to receive(:user_finder).and_return(proc { |uid| "_user_#{uid}_" })
    end

    it "finds a user based on the configured find_user block" do
      expect(subject.current_user).to eq "_user_abc123_"
    end

    it "memoizes so it doesn't have to look up more than once" do
      subject.current_user
      expect(subject.instance_variable_defined?("@current_user")).to be_truthy
    end

  end
end
