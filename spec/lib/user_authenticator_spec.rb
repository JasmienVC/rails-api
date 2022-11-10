require 'rails_helper'

describe UserAuthenticator do
  describe '#perform' do
    let(:authenticator) { described_class.new('sample_code') }
    subject { authenticator.perform }
    context 'when code is incorrect' do
      let(:error) {
        double("Sawyer::Resource", error: "bad_verification_code")
      }

      before do
        allow_any_instance_of(Octokit::Client).to receive(
          :exchange_code_for_token).and_return(error)
      end
      it 'should raise an error' do
        expect{ subject }.to raise_error(
          UserAuthenticator::AuthenticationError
        )
        expect(authenticator.user).to be_nil
      end
    end

    context 'when code is correct' do
      before do
        allow_any_instance_of(Octokit::Client).to receive(
          :exchange_code_for_token).and_return('validaccesstoken')
      end
      it "should save the user if new" do
        expect{ subject }.to change{ User.count }.by(1)
      end
    end
  end
end
