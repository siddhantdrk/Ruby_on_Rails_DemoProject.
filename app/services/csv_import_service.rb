# frozen_string_literal: true

class CsvImportService
  require 'csv'
  def import_domain_data(file, user_id)
    opened_file = File.open(file.path)
    options = { headers: true }

    # Make an object in your bucket for your upload
    obj = S3_BUCKET.objects["#{user_id}/data/#{file.original_filename}"]
    # Upload the file
    obj.write(
      file: file,
      acl: :public_read
    )

    CSV.foreach(opened_file, **options) do |row|
      # map the CSV columns to your database columns
      domain_data_hash = {}
      domain_data_hash[:user_id] = user_id
      domain_data_hash[:file_name] = File.basename(file.path)
      domain_data_hash[:date] = row['date']
      domain_data_hash[:domain_rating] = row['domain_rating']
      domain_data_hash[:domain_name] = row['domain_name']
      domain_data_hash[:s3_url] = obj.public_url.to_s
      domain_data_hash[:s3_name] = obj.key
      DomainDatum.find_or_create_by!(domain_data_hash)
    end

  end
end
