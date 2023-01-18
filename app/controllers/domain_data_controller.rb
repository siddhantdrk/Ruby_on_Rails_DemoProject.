# frozen_string_literal: true
class DomainDataController < ApplicationController
  require 'csv'

  # GET /domain_data or /domain_data.json
  def index
    return if current_user.nil?
    @domain_data = ::DomainDataQueryService.new.get_user_files_with_s3_url(current_user.id)
  end

  def import_file
    @domain_data = ::DomainDataQueryService.new.get_file_data(params[:file_name])
  end

  def import
    return redirect_to request.referer, notice: 'No file added' if params[:file].nil?
    return redirect_to request.referer, notice: 'Only CSV files allowed' unless params[:file].content_type == 'text/csv'

    ::CsvImportService.new.import_domain_data(params[:file], current_user.id)

    redirect_to request.referer, notice: 'Import and S3 upload started...'
  end

  def generate_insights
    @domain_data = ::DomainDataQueryService.new.generate_insights(current_user.id)
  end

  def mail_insights
    ::InsightsMailService.new.new_insights_email_service_method({ email: params[:email], mail_data: params[:mail_data] })
  end

end
