class Subscription < ApplicationRecord
  include AASM
  serialize :status_changes, Array

  belongs_to :user
  belongs_to :plan

  aasm :status, collumn: :status do
    state :initialized, initial: true
    state :active
    state :suspended
    state :cancelled

    after_all_transitions :log_status_changes

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

  def log_status_changes
    status_changes << { from: aasm(:status).from_state, to: aasm(:status).to_state }
  end
end
