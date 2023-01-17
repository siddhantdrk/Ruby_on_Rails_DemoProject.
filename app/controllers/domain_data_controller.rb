# frozen_string_literal: true
class DomainDataController < ApplicationController
  require 'csv'

  # GET /domain_data or /domain_data.json
  def index
    # byebug
    return if current_user.nil?

    @domain_data = ::DomainDataQueryService.new.get_user_files(current_user.id)
  end

  def import_file
    @domain_data = ::DomainDataQueryService.new.get_file_data(params[:file_name])
  end

  def import
    return redirect_to request.referer, notice: 'No file added' if params[:file].nil?
    return redirect_to request.referer, notice: 'Only CSV files allowed' unless params[:file].content_type == 'text/csv'

    ::CsvImportService.new.import_domain_data(params[:file])
    redirect_to request.referer, notice: 'Import started...'
  end

  def generate_insights
    @domain_data = ::DomainDataQueryService.new.generate_insights
    # redirect_to request.referer, notice: 'Generated Insights.'
  end
end
