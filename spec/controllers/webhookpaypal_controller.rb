require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Webhookpaypal', type: :request do
  describe 'POST create' do
    before do
      allow_any_instance_of(Paypal::ApiClient::Client).to receive(:cancel_subscription)
      allow_any_instance_of(Paypal::ApiClient::Client).to receive(:billing_agreement).and_return(agreement_details)

      post webhookpaypal_path, params: params
      subscription.reload
    end

    let(:agreement_details) do
      { agreement_details: { next_billing_date: '2020-07-27' } }
    end

    let(:params) do
      {
        resource_type: resource_type,
        event_type: event_type,
        resource: {
          id: resource_id,
          billing_agreement_id: resource_billing_agreement_id
        }
      }
    end

    let(:resource_type) { 'subscription' }
    let(:event_type) { 'BILLING.SUBSCRIPTION.CREATED' }
    let(:resource_id) { subscription.paypal_subscription_id }
    let(:resource_billing_agreement_id) { nil }

    let(:subscription) do
      create(:subscription,
        paypal_subscription_id: 'some_uniq_subscription_id')
    end

    context 'when event is unknown' do
      let(:event_type) { 'unkown event type' }

      it 'set the subscription to the state payment_created' do
        expect(subscription).to be_initialized
        expect(subscription).to be_payment_initialized
      end
    end

    context 'when event is BILLING.SUBSCRIPTION.CREATED' do
      let(:event_type) { 'BILLING.SUBSCRIPTION.CREATED' }

      it 'set the subscription to the state payment_created' do
        expect(subscription).to be_initialized
        expect(subscription).to be_payment_subscription_created
      end
    end

    context 'when event is BILLING.SUBSCRIPTION.ACTIVATED' do
      let(:event_type) { 'BILLING.SUBSCRIPTION.ACTIVATED' }

      it 'set the subscription to the state payment_created' do
        expect(subscription).to be_initialized
        expect(subscription).to be_payment_subscription_activated
      end
    end

    context 'when event is PAYMENT.SALE.COMPLETED' do
      let(:resource_type) { 'sale' }
      let(:event_type) { 'PAYMENT.SALE.COMPLETED' }
      let(:resource_billing_agreement_id) { subscription.paypal_subscription_id }

      it 'set the subscription to the state payment_created' do
        expect(subscription).to be_active
        expect(subscription).to be_payment_sale_completed
      end
    end

    context 'when event is BILLING.SUBSCRIPTION.CANCELLED' do
      let(:resource_type) { 'subscription' }
      let(:event_type) { 'BILLING.SUBSCRIPTION.CANCELLED' }
      let(:resource_id) { subscription.paypal_subscription_id }

      it 'set the subscription to the state payment_subscription_canceled' do
        expect(subscription).to be_canceled
        expect(subscription).to be_payment_subscription_canceled
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
