require 'csv'
class CsvDb
  class << self
    def convert_save(target_model, csv_data, options = {}, &block)
      options = { headers: true, header_converters: :symbol }.merge(options.except(:columns))
      csv_file = csv_data.read
      ActiveRecord::Base.transaction do
        CSV.parse(csv_file, options) do |row|
          data = row.to_hash
          if data.present? && data.any?
            if (block_given?)
              block.call(target_model, data)
            else
              target_model.create!(data)
            end
          end
        end
      end
    end
  end
end
