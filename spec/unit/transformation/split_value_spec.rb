# frozen_string_literal: true

require_relative '../../../lib/transformation/split_value'

describe Transformation::SplitValue do
  subject(:transform) { described_class.new(transform_config) }

  let(:record) { { record_id: 1, test_field: 'test,value,suffix' } }
  let(:transform_config) { { field: 'test_field', parts: { 1 => 'new_field' } } }
  let(:expected) { record.merge(new_field: 'value') }

  describe '#transform' do
    context 'when the delimiter is not specified' do
      include_examples 'transform' do
        let(:unmatched_record) { record.merge(test_field: 'test-value-suffix') }
      end
    end

    context 'when a multi-character delimiter is specified' do
      let(:record) { super().merge(test_field: 'test|@|value|@|suffix') }
      let(:transform_config) { super().merge(delimiter: '|@|') }

      include_examples 'transform' do
        let(:unmatched_config) { transform_config.merge(delimiter: ':') }
      end
    end

    context 'when a special character delimiter is specified' do
      let(:record) { super().merge(test_field: "test\tvalue\tsuffix") }
      let(:transform_config) { super().merge(delimiter: "\t") }

      include_examples 'transform' do
        let(:unmatched_config) { transform_config.merge(delimiter: "\n") }
      end
    end
  end
end
