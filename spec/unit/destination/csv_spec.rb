# frozen_string_literal: true

require_relative '../../../lib/destination/csv'

describe Destination::CSV do
  # Since we're using an actual CSV object we can't use message spies so disable
  # this cop.
  # rubocop:disable RSpec/MessageSpies
  describe '#add_record' do
    subject(:destination) { described_class.new(destination_config) }

    let(:destination_config) do
      { path: '/rspec/output.csv', headers: %w[record_id first_name last_name address_street] }
    end
    let(:records) do
      [
        { record_id: 1, first_name: 'Shredward', last_name: 'Whiskers' },
        { record_id: 2, first_name: 'Timmy', last_name: 'Tester' },
        { record_id: 'C-40', first_name: 'Bobbert', last_name: '"Bobby" Bobberson',
          address: { street: '123 street road' } }
      ]
    end
    let(:csv) { CSV.new(StringIO.new, write_headers: true, headers: destination_config[:headers]) }

    before do
      allow(CSV).to receive(:open).and_return(csv)
    end

    it 'writes the record to the file' do
      expect(csv).to receive(:puts)

      destination.add_record(records[0])
    end

    it 'properly formats the record' do
      expect(csv).to receive(:puts).with(['C-40', 'Bobbert', '"Bobby" Bobberson', '123 street road'])

      destination.add_record(records[2])
    end
  end
  # rubocop:enable RSpec/MessageSpies
end
