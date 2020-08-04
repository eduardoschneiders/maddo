# rubocop:disable Metrics/BlockLength
require 'rails_helper'

describe Subscription, type: :model, vcr: {
  cassette_name: 'subscription/activate_subscription',
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
      subject.complete_sale_payment!
    end

    it 'should be activated' do
      expect(subject.reload).to be_active
    end

    it 'Should update billing dates' do
      expect(subject.next_billing_at).to eql(Date.new(2020, 8, 0o1))
      expect(subject.last_paid_at).to eql(Date.new(2020, 7, 26))
    end
  end

  context 'when user activate new subscription, and there is a previous subscription' do
    subject do
      create(
        :subscription,
        paypal_subscription_id: 'I-3PPUTTY7H9E3',
        user: user
      )
    end

    before do
      previsou_subscription
      subject.complete_sale_payment!
    end

    let(:user) { create(:user) }
    let(:previsou_subscription) do
      create(
        :subscription,
        paypal_subscription_id: 'I-ID-TO-CANCEL',
        user: user
      )
    end

    it 'should cancel previous subscriptions' do
      expect(previsou_subscription.reload).to be_canceled
    end

    it 'should activate last subscription' do
      expect(subject.reload).to be_active
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
      expect { subject.complete_sale_payment! }.to raise_error do |error|
        expect(error).to be_a(Paypal::Errors::BillingAgreementNotFound)
      end

      expect(subject).to be_initialized
    end
  end
end
# rubocop:enable Metrics/BlockLength
