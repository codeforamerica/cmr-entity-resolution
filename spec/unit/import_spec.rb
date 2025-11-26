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

  describe '#import_from (concurrency)' do
    before do
      allow(Source::CSV).to receive(:new).with(hash_including(name: :factory)).and_return(sources[:factory])
      allow(Source::CSV).to receive(:new).with(hash_including(name: :test)).and_return(sources[:test])

      allow(Senzing).to receive(:new).and_return(senzing)

      allow(Filter).to receive(:filter).and_return(true)
      allow(Transformation).to receive(:transform).and_return(record)
    end

    context 'when processing records' do
      it 'returns true when all records succeed' do
        allow(senzing).to receive(:upsert_record).and_return(true)

        expect(import.import_from(:factory)).to be(true)
      end

      it 'returns false if any record fails' do
        allow(senzing).to receive(:upsert_record).and_return(false)

        expect(import.import_from(:factory)).to be(false)
      end

      it 'handles thread exceptions' do
        allow(senzing).to receive(:upsert_record).and_raise(StandardError, 'API Error')
        allow(config.logger).to receive(:error)

        import.import_from(:factory)
        expect(config.logger).to have_received(:error).with(/Failed to upsert record/)
      end
    end

    it 'configures the thread pool correctly' do
      allow(Concurrent::ThreadPoolExecutor).to receive(:new).and_call_original
      allow(senzing).to receive(:upsert_record).and_return(true)

      import.import_from(:factory)

      expect(Concurrent::ThreadPoolExecutor).to have_received(:new).with(hash_including(fallback_policy: :caller_runs))
    end
  end
end
