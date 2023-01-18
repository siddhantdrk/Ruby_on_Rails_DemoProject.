# frozen_string_literal: true

class InsightsMailService
  def new_insights_email_service_method(params)
    ::InsightsMailer.with(insights_data: params).new_insights_email.deliver_now
  end
end
