# Preview all emails at http://localhost:3000/rails/mailers/insight_mailer
class InsightMailerPreview < ActionMailer::Preview
  def new_insights_email
    # Set up a temporary order for the preview
    insights_data = { :email => 'siddhant.khobragade@synaptic.com', 'commit'=>'Send', :mail_data => {'max_value' => ['amazon.com', '9'], 'median_value' => ['synaptic.com', '7'], 'min_value' => ['uber.com', '3'] } }
    ::InsightsMailer.with(:insights_data => insights_data).new_insights_email
  end
end
