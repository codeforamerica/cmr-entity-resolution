# frozen_string_literal: true

require_relative '../../lib/config'
require_relative '../../lib/transformation'

describe Transformation do
  let(:config) { build(:config) }
  let(:record) { { record_id: 1 } }
  let(:transform_config) { [{ transform: 'StaticValue' }] }

  describe '.transform' do
    subject(:result) { described_class.transform(config, record, transform_config) }

    let(:transform) { instance_double(Transformation::StaticValue) }
    let(:transformed_record) { record }

    before do
      allow(described_class).to receive(:transform_from_config).and_return(transform)
      allow(transform).to receive(:transform).with(record) do |record|
        record.merge!(transformed_record)
      end
    end

    context 'when the record is transformed' do
      let(:transformed_record) { record.merge({ test_field: 'test_value' }) }

      it 'returns the modified record' do
        expect(result).to eq(transformed_record)
      end
    end

    context 'when the record is not transformed' do
      it 'returns the unmodified record' do
        expect(result).to eq(record)
      end
    end
  end

  describe '.transform_from_config' do
    subject(:concrete) { described_class.transform_from_config(transform_config.first) }

    context 'when a valid transform type is provided' do
      it 'returns the proper transformer' do
        expect(concrete).to be_a(Transformation::StaticValue)
      end
    end

    context 'when an invalid transform type is provided' do
      let(:transform_config) { [{ transform: 'Invalid' }] }

      it 'raises an exception' do
        expect { concrete }.to raise_error(Transformation::InvalidTransform)
      end
    end
  end
end
