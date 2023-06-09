# frozen_string_literal: true

require_relative '../../../lib/destination/mongo'

describe Destination::Mongo do
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
    let(:client) do
      instance_double(Mongo::Client).tap do |client|
        allow(client).to receive(:use).and_return(client)
        allow(client).to receive(:[]).and_return(collection)
      end
    end
    let(:collection) { instance_double(Mongo::Collection) }

    before do
      allow(Mongo::Client).to receive(:new).and_return(client)
    end

    it 'writes the record to the database' do
      expect(collection).to receive(:insert_one)

      destination.add_record(records[0])
    end

    it 'properly formats the record' do
      expect(collection).to receive(:insert_one).with(records[2])

      destination.add_record(records[2])
    end
  end
end
