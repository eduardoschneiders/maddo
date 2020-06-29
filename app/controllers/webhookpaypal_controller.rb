class WebhookpaypalController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    Rails.logger.info(params.inspect)

    head :created
  end
end
