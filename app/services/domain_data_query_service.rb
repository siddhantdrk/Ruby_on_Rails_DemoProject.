# frozen_string_literal: true

class DomainDataQueryService

  def get_user_files(user_id)
    data_hash = {}
    data_hash['file_data']=DomainDatum.select(:file_name).distinct.where(user_id: user_id)
    data_hash['is_insights_generated'] = false
    data_hash
  end

  def clear_data
    DomainDatum.delete_all
  end

  def generate_insights

    all_data = DomainDatum.select(:date, :domain_rating, :domain_name)

    data_hash = {}
    data_hash['max_value'] = DomainDatum.order(domain_rating: :desc).limit(1).pluck(:domain_name, :domain_rating)[0]
    data_hash['median_value'] = median('domain_rating')
    data_hash['min_value'] = DomainDatum.order(domain_rating: :asc).limit(1).pluck(:domain_name, :domain_rating)[0]

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
    data_hash['is_insights_generated'] = true
    data_hash
  end

  def get_file_data(file_name)
    DomainDatum.select(:date, :domain_rating, :domain_name).where(file_name: file_name)
  end

  private

  def median(column_name)
    count = DomainDatum.count
    median_index = (count / 2)
    # order by the given column and pluck out the value exactly halfway
    DomainDatum.order(column_name).offset(median_index).limit(1).pluck(:domain_name, column_name)[0]
  end


end
