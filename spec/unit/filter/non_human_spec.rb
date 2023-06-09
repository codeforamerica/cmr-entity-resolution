# frozen_string_literal: true

require_relative '../../../lib/filter/non_human'

describe Filter::NonHuman do
  subject(:filter) { described_class.new }

  let(:record) do
    { record_id: 1, PRIMARY_NAME_FIRST: 'Shredward', PRIMARY_NAME_MIDDLE: 'Shreddy', PRIMARY_NAME_LAST: 'Whiskers' }
  end

  describe '#filter' do
    context 'when the name does not match any terms' do
      include_examples 'filter', true
    end

    context 'when the name matches an anywhere term' do
      [
        { PRIMARY_NAME_FIRST: 'Shredward AND ASSOC' },
        { PRIMARY_NAME_MIDDLE: 'SPORTS & ENT Shreddy' },
        { PRIMARY_NAME_LAST: 'Whiskers "EXPUNGED" Seal' }
      ].each do |updates|
        include_examples 'filter', false do
          let(:record) { super().merge(updates) }
        end
      end
    end

    context 'when the name matches a beginning term' do
      let(:record) { super().merge(PRIMARY_NAME_FIRST: 'REGISTER AGENT Shredward') }

      include_examples 'filter', false
    end

    context 'when the name matches an ending term' do
      let(:record) { super().merge(PRIMARY_NAME_LAST: 'Whiskers AUTO DADDY') }

      include_examples 'filter', false
    end

    context 'when the name matches an exact term' do
      let(:record) do
        super().merge(PRIMARY_NAME_FIRST: 'EXPUNGED', PRIMARY_NAME_MIDDLE: 'DEFENDANT', PRIMARY_NAME_LAST: 'RECORD')
      end

      include_examples 'filter', false
    end

    context 'when the name matches a middle term' do
      let(:record) { super().merge(PRIMARY_NAME_MIDDLE: 'Shreddy FOUNDATION') }

      include_examples 'filter', false
    end
  end
end
