# frozen_string_literal: true

class DomainDataQueryService

  def get_user_files_with_s3_url(user_id)
    DomainDatum.select(:file_name, :s3_url, :s3_name).distinct.where(user_id: user_id)
  end

  def clear_data
    DomainDatum.delete_all
  end

  def generate_insights(user_id)

    all_data = DomainDatum.select(:date, :domain_rating, :domain_name).where(user_id: user_id)

    data_hash = {}
    data_hash['max_value'] = DomainDatum.where(user_id: user_id).order(domain_rating: :desc).limit(1).pluck(:domain_name, :domain_rating)[0]
    data_hash['median_value'] = median('domain_rating', user_id)
    data_hash['min_value'] = DomainDatum.where(user_id: user_id).order(domain_rating: :asc).limit(1).pluck(:domain_name, :domain_rating)[0]

    time_series_map = all_data.inject({}) do |result_hash, obj|
      result_hash[obj.domain_name] = [] if result_hash[obj.domain_name].nil?
      result_hash[obj.domain_name] << [obj.date, obj.domain_rating.to_i]
      # p(result_hash)
      result_hash
    end

    data_hash['time_series_data'] = []
    time_series_map.each_key do |key|
      data_hash['time_series_data'] << { name: key, data: time_series_map[key] }
    end

    data_hash
  end

  def get_file_data(file_name)
    DomainDatum.select(:date, :domain_rating, :domain_name).where(file_name: file_name)
  end

  private

  def median(column_name, user_id)
    count = DomainDatum.where(user_id: user_id).count
    median_index = (count / 2)
    # order by the given column and pluck out the value exactly halfway
    DomainDatum.where(user_id: user_id).order(column_name).offset(median_index).limit(1).pluck(:domain_name, column_name)[0]
  end


end
