# frozen_string_literal: true

require_relative '../../../lib/filter/value_is'

describe Filter::ValueIs do
  subject(:filter) { described_class.new(filter_config) }

  let(:filter_config) { { field: 'test_field', value: 'test value' } }
  let(:record) { { record_id: 1, test_field: 'test value' } }

  describe '#filter' do
    context 'when the operator is not reversed' do
      context 'when the value matches' do
        include_examples 'filter', true
      end

      context 'when the value does not match' do
        let(:filter_config) { super().merge(value: 'bad value') }

        include_examples 'filter', false
      end
    end

    context 'when the operator is reversed' do
      let(:filter_config) { super().merge(inverse: true) }

      context 'when the value matches' do
        include_examples 'filter', false
      end

      context 'when the value does not match' do
        let(:filter_config) { super().merge(value: 'bad value') }

        include_examples 'filter', true
      end
    end
  end
end
