# frozen_string_literal: true

require_relative '../../lib/config'
require_relative '../../lib/import'

RSpec.describe Import do
  subject(:import) { described_class.new(config) }

  let(:config) { build(:config) }
  let(:senzing) { build(:senzing) }

  describe '#import' do
    let(:source) { build(:source_csv) }
    let(:senzing) { build(:senzing) }
    let(:record) { { id: 1, first_name: 'Shredward', last_name: 'Whiskers' } }

    before do
      allow(Source::CSV).to receive(:new).and_return(source)
      allow(Senzing).to receive(:new).and_return(senzing)
      allow(Filter).to receive(:filter).and_return(included)
      allow(Transformation).to receive(:transform).and_return(record)
    end

    context 'when the record is not filtered out' do
      let(:included) { true }

      context 'when the record has not been transformed' do
        it 'sends the unmodified record to senzing' do
          import.import

          expect(senzing).to have_received(:upsert_record).with(record)
        end
      end

      context 'when the record has been transformed' do
        let(:record) { super().merge(test_field: 'test value') }

        it 'sends the modified record to senzing' do
          import.import

          expect(senzing).to have_received(:upsert_record).with(record)
        end
      end
    end

    context 'when the record is filtered out' do
      let(:included) { false }

      it 'does not send the record to senzing' do
        import.import

        expect(senzing).not_to have_received(:upsert_record)
      end
    end
  end

  describe '#senzing' do
    include_examples 'proxy method', :senzing, Senzing do
      let(:object) { senzing }
    end
  end
end
