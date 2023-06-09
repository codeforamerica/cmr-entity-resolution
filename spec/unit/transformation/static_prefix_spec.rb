# frozen_string_literal: true

require_relative '../../../lib/transformation/static_prefix'

describe Transformation::StaticPrefix do
  subject(:transform) { described_class.new(transform_config) }

  let(:record) { { record_id: 1, test_field: 'test value', empty_field: '' } }
  let(:transform_config) { { field: 'test_field', prefix: 'RSPEC' } }
  let(:expected) { record.merge(test_field: 'RSPECtest value') }

  describe '#transform' do
    context 'when configured to apply to non-empty fields only' do
      include_examples 'transform' do
        let(:unmatched_config) { transform_config.merge(field: 'empty_field') }
      end
    end

    context 'when configured to apply to empty fields as well' do
      let(:transform_config) { super().merge(field: 'empty_field', if_not_empty: false) }
      let(:expected) { record.merge(empty_field: 'RSPEC') }

      include_examples 'transform', unmodified: false
    end
  end
end
