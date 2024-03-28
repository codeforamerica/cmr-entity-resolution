# frozen_string_literal: true

FactoryBot.define do
  factory :source_csv, class: 'Source::CSV' do
    name { :factory }

    initialize_with { new({ field_map: [], name:, type: 'CSV' }) }

    after(:build) do |factory|
      record = { id: 1, first_name: 'Shredward', last_name: 'Whiskers' }
      allow(factory).to receive(:each).and_yield(record)
    end
  end
end
