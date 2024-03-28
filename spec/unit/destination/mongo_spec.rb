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
        allow(client).to receive_messages(use: client, :[] => collection)
      end
    end
    let(:collection) do
      instance_double(Mongo::Collection).tap do |collection|
        allow(collection).to receive(:insert_one)
      end
    end

    before do
      allow(Mongo::Client).to receive(:new).and_return(client)
    end

    it 'writes the record to the database' do
      destination.add_record(records[0])
      expect(collection).to have_received(:insert_one)
    end

    it 'properly formats the record' do
      destination.add_record(records[2])
      expect(collection).to have_received(:insert_one).with(records[2])
    end
  end
end
