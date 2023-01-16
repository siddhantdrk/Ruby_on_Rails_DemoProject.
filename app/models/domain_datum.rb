class DomainDatum < ApplicationRecord

  def self.get_user_files(user_id)
    DomainDatum.select(:file_name).distinct.where(user_id: user_id)
  end

  def self.clear_data
    DomainDatum.delete_all
  end

  def self.get_file_data(file_name)
    data_hash = {}
    data_hash['table_data'] = DomainDatum.select(:date, :domain_rating, :domain_name).where(file_name: file_name)
    data_hash['max_value'] = DomainDatum.where(file_name: file_name).maximum(:domain_rating)
    data_hash['median_value'] = median('domain_rating', file_name)
    time_series_map = data_hash['table_data'].inject({}) do |result_hash, obj|
      result_hash[obj.domain_name] = [] if result_hash[obj.domain_name].nil?
      result_hash[obj.domain_name] << [obj.date, obj.domain_rating.to_i]
      p(result_hash)
    end
    data_hash['time_series_data'] = []
    time_series_map.each_key do |key|
      data_hash['time_series_data'] << { name: key, data: time_series_map[key] }
    end
    data_hash
  end

  def self.median(column_name, file_name)
    count = DomainDatum.where(file_name: file_name).count
    puts(count)
    median_index = (count / 2)
    # order by the given column and pluck out the value exactly halfway
    DomainDatum.where(file_name: file_name).order(column_name).offset(median_index).limit(1).pluck(column_name)[0]
  end

end
