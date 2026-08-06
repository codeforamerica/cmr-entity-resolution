# frozen_string_literal: true

require_relative '../../../lib/destination/informix'

describe Destination::Informix do
  subject(:destination) { described_class.new(destination_config) }

  let(:destination_config) do
    {
      table: 'rspec',
      host: 'rspec.com',
      database: 'rspec',
      username: 'swhiskers',
      password: 'clearmyrecrod',
      schema: 'aoc',
      security: false,
      unique_key: %w[srcdb party_num]
    }
  end
  let(:record) { { srcdb: 'CMR', party_num: '123', first_name: 'Shredward' } }
  let(:db) { Sequel.mock(numrows: numrows) }
  let(:numrows) { 0 }

  before do
    allow(Sequel).to receive(:connect).and_return(db)
  end

  describe '#add_record' do
    context 'when no existing record matches the key columns' do
      it 'inserts the record' do
        destination.add_record(record)

        expect(db.sqls).to include(
          "INSERT INTO rspec (srcdb, party_num, first_name) VALUES ('CMR', '123', 'Shredward')"
        )
      end
    end

    context 'when an existing record matches the key columns' do
      let(:numrows) { 1 }

      it 'updates the record instead of inserting' do
        destination.add_record(record)

        expect(db.sqls).to include(
          "UPDATE rspec SET srcdb = 'CMR', party_num = '123', first_name = 'Shredward' " \
          "WHERE ((srcdb = 'CMR') AND (party_num = '123'))"
        )
      end

      it 'does not insert a new record' do
        destination.add_record(record)

        expect(db.sqls.grep(/\AINSERT/)).to be_empty
      end
    end

    context 'when destination.unique_key is not configured' do
      let(:destination_config) { super().except(:unique_key) }

      it 'raises an ArgumentError' do
        expect { destination.add_record(record) }.to raise_error(ArgumentError, /unique_key/)
      end
    end

    context 'when the record is missing a key column' do
      let(:record) { { srcdb: 'CMR', first_name: 'Shredward' } }

      it 'raises an ArgumentError' do
        expect { destination.add_record(record) }.to raise_error(ArgumentError, /missing key columns: party_num/)
      end
    end

    context 'when the record has a blank key column' do
      let(:record) { { srcdb: 'CMR', party_num: '  ', first_name: 'Shredward' } }

      it 'raises an ArgumentError' do
        expect { destination.add_record(record) }.to raise_error(ArgumentError, /blank key columns: party_num/)
      end
    end
  end
end
