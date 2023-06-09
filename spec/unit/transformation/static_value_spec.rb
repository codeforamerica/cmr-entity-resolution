# frozen_string_literal: true

require_relative '../../../lib/transformation/static_value'

describe Transformation::StaticValue do
  subject(:transform) { described_class.new(transform_config) }

  let(:record) { { record_id: 1 } }
  let(:transform_config) { { field: 'new_field', value: 'test value' } }
  let(:expected) { record.merge(new_field: 'test value') }

  describe '#transform' do
    context 'when the configured field does not exist' do
      include_examples 'transform', unmodified: false
    end

    context 'when the configured field exists' do
      let(:record) { super().merge(new_field: 'existing value') }

      include_examples 'transform', unmodified: false
    end
  end
end
