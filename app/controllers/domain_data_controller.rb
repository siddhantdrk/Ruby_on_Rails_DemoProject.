# frozen_string_literal: true

class DomainDataController < ApplicationController
  require 'csv'

  # GET /domain_data or /domain_data.json
  def index
    # byebug
    return if current_user.nil?

    @domain_data = DomainDatum.get_user_files(current_user.id)
  end

  def import_file
    @domain_data = DomainDatum.get_file_data(params[:file_name])
  end

  def import
    return redirect_to request.referer, notice: 'No file added' if params[:file].nil?
    return redirect_to request.referer, notice: 'Only CSV files allowed' unless params[:file].content_type == 'text/csv'

    import_domain_data(params[:file])
    redirect_to request.referer, notice: 'Import started...'
  end

  private

  def import_domain_data(file)
    opened_file = File.open(file.path)
    options = { headers: true }
    CSV.foreach(opened_file, **options) do |row|
      # map the CSV columns to your database columns
      domain_data_hash = {}
      domain_data_hash[:user_id] = current_user.id
      domain_data_hash[:file_name] = File.basename(file.path)
      domain_data_hash[:date] = row['date']
      domain_data_hash[:domain_rating] = row['domain_rating']
      domain_data_hash[:domain_name] = row['domain_name']
      DomainDatum.find_or_create_by!(domain_data_hash)
    end
  end
end
