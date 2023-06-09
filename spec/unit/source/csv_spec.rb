# frozen_string_literal: true

require_relative '../../../lib/source/csv'

describe Source::CSV do
  describe '#each' do
    let(:source_config) { { parth: '/rspec/test.csv' } }
    let(:headers) { %w[record_id first_name last_name] }

    include_examples 'source' do
      before do
        # Generate a CSV object instead of reading form the file system.
        contents = CSV.generate do |csv|
          csv << CSV::Row.new(headers, headers, true)
          rows.each do |row|
            csv << CSV::Row.new(row.keys, row.values)
          end
        end

        csv = CSV.new(contents, headers: true)
        allow(CSV).to receive(:open).and_return(csv)
      end
    end
  end
end
