class Subscription < ApplicationRecord
  include AASM
  serialize :status_changes, Array
  serialize :status_changes_attempts, Array
  serialize :payment_status_changes, Array

  belongs_to :user
  belongs_to :plan

  aasm :status, whiny_transitions: false, collumn: :status do
    state :initialized, initial: true
    state :active
    state :suspended
    state :cancelled

    after_all_transitions :log_status_changes
    before_all_events :log_status_changes_attempts

    event :activate do
      transitions from: [:initialized], to: :active
    end

    event :suspend do
      transitions from: [:initialized, :active], to: :suspended
    end

    event :cancel do
      transitions from: [:initialized, :active, :suspended], to: :cancelled
    end

    event :initialize_again do
      transitions from: [:cancelled], to: :initialized
    end
  end

  private

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
end
