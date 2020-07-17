require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Subscription, type: :model do
  subject { create :subscription }

  shared_examples 'subscription is initialized' do
    it 'subscriptions should be initialized' do
      expect(subject).to be_initialized
    end
  end

  shared_examples 'subscription is activated' do
    it 'subscriptions should be active' do
      expect(subject.reload).to be_active
    end
  end

  shared_examples 'subscription is canceled' do
    it 'subscriptions should be canceled' do
      expect(subject.reload).to be_canceled
    end
  end

  it 'should has the initialized state' do
    expect(subject).to be_payment_initialized
  end

  it_should_behave_like 'subscription is initialized'

  describe 'payment_subscription_created' do
    before do
      subject.create_subscription_payment!
    end

    it 'should update payment status' do
      expect(subject).to be_payment_subscription_created
    end

    it_should_behave_like 'subscription is initialized'
  end

  describe 'payment_subscription_activated' do
    before do
      subject.activate_subscription_payment!
    end

    it 'should update payment status' do
      expect(subject).to be_payment_subscription_activated
    end

    it_should_behave_like 'subscription is initialized'
  end

  describe 'payment_sale_completed' do
    before do
      subject.complete_sale_payment!
    end

    it 'should update payment status' do
      expect(subject).to be_payment_sale_completed
    end

    it_should_behave_like 'subscription is activated'
  end

  describe 'payment_subscription_canceled' do
    before do
      subject.cancel_subscription_payment!
    end

    it 'should update payment status' do
      expect(subject).to be_payment_subscription_canceled
    end

    it_should_behave_like 'subscription is canceled'
  end
end
# rubocop:enable Metrics/BlockLength
