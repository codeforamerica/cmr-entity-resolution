# frozen_string_literal: true

require_relative '../../lib/config'
require_relative '../../lib/export'

RSpec.describe Export do
  subject(:export) { described_class.new(config) }

  let(:config) { build(:config) }
  let(:destination) { build(:destination_csv) }

  describe '#from_file' do
    let(:record) { { RECORD_ID: 1, PRIMARY_NAME_FIRST: 'Shredward', PRIMARY_NAME_LAST: 'Whiskers' } }
    let(:mapped) { { entity_id: 2, first_name: 'Shredward', last_name: 'Whiskers', record_id: 1 } }
    let(:entity) do
      {
        RESOLVED_ENTITY: {
          ENTITY_ID: 2,
          RECORDS: [record]
        }
      }.to_json
    end

    before do
      allow(File).to receive(:readlines).and_return([entity])
      allow(Destination::CSV).to receive(:new).and_return(destination)
      allow(Transformation).to receive(:transform).and_return(record.merge(ENTITY_ID: 2))
    end

    context 'when the record has not been transformed' do
      it 'sends the unmodified record to the destination' do
        export.from_file

        expect(destination).to have_received(:add_record).with(mapped)
      end
    end

    context 'when the record has been transformed' do
      let(:record) { super().merge(PRIMARY_NAME_FIRST: 'Bobert') }
      let(:mapped) { super().merge(first_name: 'Bobert') }

      it 'sends the modified record to the destination' do
        export.from_file

        expect(destination).to have_received(:add_record).with(mapped)
      end
    end
  end
end
