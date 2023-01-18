# frozen_string_literal: true
class InsightsMailer < ApplicationMailer
  def new_insights_email
    @insights_data = params[:insights_data][:mail_data]
    mail(to: params[:email], subject: 'Insights generated by Data Analytics Platform.')
  end
end