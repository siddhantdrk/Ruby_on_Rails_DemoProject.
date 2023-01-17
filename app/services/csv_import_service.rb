# frozen_string_literal: true

class CsvImportService
  require 'csv'
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
