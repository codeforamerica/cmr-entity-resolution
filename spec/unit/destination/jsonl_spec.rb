# frozen_string_literal: true

require_relative '../../../lib/destination/jsonl'

describe Destination::JSONL do
  # Since we're using an actual StringIO object we can't use message spies so
  # disable this cop.
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
    let(:file) { StringIO.new }

    before do
      allow(File).to receive(:open).and_return(file)
    end

    it 'writes the record to the file' do
      expect(file).to receive(:puts)

      destination.add_record(records[0])
    end

    it 'properly formats the record' do
      expect(file).to receive(:puts).with(records[2].to_json)

      destination.add_record(records[2])
    end
  end
  # rubocop:enable RSpec/MessageSpies
end
