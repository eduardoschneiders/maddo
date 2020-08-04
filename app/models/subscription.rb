# rubocop:disable Metrics/BlockLength, Metrics/ClassLength
class Subscription < ApplicationRecord
  include AASM
  serialize :status_changes, Array
  serialize :status_changes_attempts, Array
  serialize :payment_status_changes, Array
  serialize :payment_status_changes_attempts, Array

  belongs_to :user
  belongs_to :plan

  aasm :status, whiny_transitions: false, collumn: :status do
    state :initialized, initial: true
    state :active
    state :suspended
    state :canceled

    after_all_transitions :log_status_changes
    before_all_events :log_status_changes_attempts

    event :activate do
      transitions from: [:initialized], to: :active
    end

    event :suspend do
      transitions from: [:initialized, :active], to: :suspended
    end

    event :cancel, before: :cancel_on_gateway! do
      transitions from: [:initialized, :active, :suspended], to: :canceled
    end
  end

  aasm :payment_status, whiny_transitions: false, collumn: :payment_status do
    state :payment_initialized, initial: true
    state :payment_subscription_created
    state :payment_subscription_activated
    state :payment_sale_completed
    state :payment_subscription_canceled

    after_all_transitions :log_payment_status_changes
    before_all_events :log_payment_status_changes_attempts

    event :create_subscription_payment do
      transitions from: [:payment_initialized], to: :payment_subscription_created
    end

    event :activate_subscription_payment do
      transitions from: [:payment_initialized, :payment_subscription_created], to: :payment_subscription_activated
    end

    event :complete_sale_payment, after: :activate_subscription do
      transitions from: [
        :payment_initialized,
        :payment_subscription_created,
        :payment_subscription_activated,
        :payment_sale_completed
      ],
                  to: :payment_sale_completed
    end

    event :cancel_subscription_payment, after: :cancel_subscription do
      transitions from: [
        :payment_initialized,
        :payment_subscription_created,
        :payment_subscription_activated,
        :payment_sale_completed
      ],
                  to: :payment_subscription_canceled
    end
  end

  private

  def activate_subscription
    update_billing_dates!
    cancel_previous_subscriptions
    activate!
  end

  def cancel_previous_subscriptions
    user.previous_subscriptions.each(&:cancel!)
  end

  def cancel_subscription
    cancel! unless canceled?
  end

  def cancel_on_gateway!
    update!(canceled_at: Date.today)
    return if payment_subscription_canceled?

    paypal_client.cancel_subscription(paypal_subscription_id: paypal_subscription_id)
  rescue RestClient::BadRequest
    raise_billing_not_found
  end

  def log_status_changes_attempts
    status_changes_attempts << build_status_change_attempt
    save!
  end

  def log_status_changes
    status_changes << build_status_change
    save!
  end

  def build_status_change_attempt
    {
      time: Time.now,
      from: status.to_s,
      to: aasm(:status).current_event.to_s
    }
  end

  def build_status_change
    {
      time: Time.now,
      from: aasm(:status).from_state.to_s,
      to: aasm(:status).to_state.to_s
    }
  end

  def log_payment_status_changes_attempts
    payment_status_changes_attempts << build_payment_status_change_attempt
    save!
  end

  def log_payment_status_changes
    payment_status_changes << build_payment_status_change
    save!
  end

  def build_payment_status_change_attempt
    {
      time: Time.now,
      from: payment_status.to_s,
      to: aasm(:payment_status).current_event.to_s
    }
  end

  def build_payment_status_change
    {
      time: Time.now,
      from: aasm(:payment_status).from_state.to_s,
      to: aasm(:payment_status).to_state.to_s
    }
  end

  def update_billing_dates!
    update!(
      next_billing_at: agreement[:agreement_details][:next_billing_date],
      expiration_date: agreement[:agreement_details][:next_billing_date],
      last_paid_at: agreement[:agreement_details][:last_payment_date]
    )
  end

  def agreement
    @agreement ||= fetch_agreement
  rescue RestClient::BadRequest
    raise_billing_not_found
  end

  def fetch_agreement
    paypal_client.billing_agreement(paypal_subscription_id: paypal_subscription_id)
  end

  def raise_billing_not_found
    raise Paypal::Errors::BillingAgreementNotFound.new(
      paypal_subscription_id: paypal_subscription_id
    )
  end

  def paypal_client
    @paypal_client ||= Paypal::ApiClient::Client.new
  end
end
# rubocop:enable Metrics/BlockLength, Metrics/ClassLength
