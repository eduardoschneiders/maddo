class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :subscriptions
  has_many :orders

  def current_subscription
    subscriptions.order(created_at: :asc).last
  end

  def previous_subscriptions
    subscriptions.reject do |subscription|
      subscription == current_subscription
    end
  end
end
