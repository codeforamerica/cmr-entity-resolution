# frozen_string_literal: true

FactoryBot.define do
  factory :source_csv, class: 'Source::CSV' do
    initialize_with { new({ field_map: [] }) }

    after(:build) do |factory|
      record = { id: 1, first_name: 'Timmy', last_name: 'Testaburger' }
      allow(factory).to receive(:each).and_yield(record)
    end
  end
end
