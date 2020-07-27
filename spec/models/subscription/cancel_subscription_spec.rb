# rubocop:disable Metrics/BlockLength
require 'rails_helper'

describe Subscription, type: :model, vcr: {
  cassette_name: 'subscription/cancel_subscription',
  record: :once
} do
  context 'when billing agreement exist' do
    subject do
      create(
        :subscription,
        paypal_subscription_id: 'I-3PPUTTY7H9E3'
      )
    end

    before do
      travel_to Date.new(2020, 7, 26)
      subject.cancel!
    end

    it 'should be canceled' do
      expect(subject.reload).to be_canceled
    end

    it 'Should update cancel date' do
      expect(subject.canceled_at).to eql(Date.new(2020, 7, 26))
    end
  end

  context 'when billing agreement dont exist' do
    subject do
      create(
        :subscription,
        paypal_subscription_id: 'I-123'
      )
    end

    it 'should raise error' do
      expect { subject.cancel! }.to raise_error do |error|
        expect(error).to be_a(Paypal::Errors::BillingAgreementNotFound)
      end

      # expect(subject).to be_initialized
    end
  end
end
# rubocop:enable Metrics/BlockLength
