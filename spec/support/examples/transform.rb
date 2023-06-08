# frozen_string_literal: true

RSpec.shared_examples 'transform' do |modified: true, unmodified: true|
  subject(:transform) do
    defined?(transform_config) ? described_class.new(transform_config) : described_class.new
  end

  if modified
    context 'when the transformation conditions are met' do
      it 'transforms the record' do
        transform.transform(record)
        expect(record).to eq(expected)
      end
    end
  end

  if unmodified
    context 'when the transformation conditions are not met' do
      subject(:transform) do
        local_config.nil? ? described_class.new : described_class.new(local_config)
      end

      let(:local_record) { defined?(unmatched_record) ? unmatched_record : record }
      let(:local_config) do
        if defined?(unmatched_config)
          unmatched_config
        elsif defined?(transform_config)
          transform_config
        end
      end

      before do
        fail 'Unmatched config or record must be set' unless defined?(unmatched_config) || defined?(unmatched_record)
      end

      it 'does not transform the record' do
        transform.transform(local_record)
        expect(local_record).to eq(local_record)
      end
    end
  end
end
