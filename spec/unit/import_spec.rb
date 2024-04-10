# frozen_string_literal: true

require_relative '../../lib/config'
require_relative '../../lib/import'

RSpec.describe Import do
  subject(:import) { described_class.new(config) }

  let(:config) do
    build(:config, sources: { factory: { type: 'CSV' }, test: { type: 'CSV' } })
  end
  let(:sources) do
    {
      factory: build(:source_csv, name: :factory),
      test: build(:source_csv, name: :test)
    }
  end

  let(:senzing) { build(:senzing) }
  let(:record) { { id: 1, first_name: 'Shredward', last_name: 'Whiskers' } }

  describe '#import' do
    it 'imports from all sources' do
      allow(import).to receive(:import_from)

      import.import

      config.sources.each_key do |name|
        expect(import).to have_received(:import_from).with(name)
      end
    end
  end

  describe '#import_from' do
    let(:included) { true }

    before do
      allow(Source::CSV).to receive(:new).and_call_original
      allow(Source::CSV).to receive(:new).with(hash_including(name: :factory)).and_return(sources[:factory])
      allow(Source::CSV).to receive(:new).with(hash_including(name: :test)).and_return(sources[:test])

      allow(Senzing).to receive(:new).and_return(senzing)
      allow(Filter).to receive(:filter).and_return(included)
      allow(Transformation).to receive(:transform).and_return(record)
    end

    it 'imports from the specified source' do
      import.import_from(:test)

      expect(sources[:test]).to have_received(:each)
    end

    it 'does not import from other sources' do
      import.import_from(:test)

      expect(sources[:factory]).not_to have_received(:each)
    end

    context 'when the record is not filtered out' do
      context 'when the record has not been transformed' do
        it 'sends the unmodified record to senzing' do
          import.import_from(:factory)

          expect(senzing).to have_received(:upsert_record).with(record)
        end
      end

      context 'when the record has been transformed' do
        let(:record) { super().merge(test_field: 'test value') }

        it 'sends the modified record to senzing' do
          import.import_from(:factory)

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
